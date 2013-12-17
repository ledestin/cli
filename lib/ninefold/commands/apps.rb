module Ninefold
  class Ninefold::Command::Apps < Ninefold::Command
    desc "list", "list the apps registered to this account"
    def list
      load_apps do |apps|
        if apps.empty?
          say "Apparently you don't have any active app on this account", :yellow
        else
          apps.each do |app|
            puts " - #{app}"
          end

          puts "\n"
        end
      end
    end

    desc "info", "print out info about an app"
    def info
      pick_app do |app|
        title "Getting the app info..."

        host.get "/apps/#{app.id}" do |response|
          if response.ok?
            response[:app].each do |key, value|
              puts "#{key.capitalize.ljust(9)} #{value}"
            end
          end
        end
      end
    end

    desc "console", "run the rails console on an app"
    option :public_key, aliases: '-k', desc: "your public key location", default: "~/.ssh/id_rsa.pub"
    def console
      run_app_command :console
    end

    desc "dbconsole", "run the rails dbconsole"
    option :public_key, aliases: '-k', desc: "your public key location", default: "~/.ssh/id_rsa.pub"
    def dbconsole
      run_app_command :dbconsole
    end

    desc "rake", "run rake tesks in an app"
    option :public_key, aliases: '-k', desc: "your public key location", default: "~/.ssh/id_rsa.pub"
    def rake(name, *args)
      run_app_command :rake, ([name] + args).join(' ')
    end

  protected

    def load_apps(&block)
      require_user

      title "Requesting your apps list..."
      show_spinner

      App.load do |apps|
        hide_spinner

        block.call apps
      end
    end

    def pick_app(&block)
      load_apps do |apps|
        block.call interaction(:pickapp, apps)
      end
    end

    def run_app_command(name, *args, &block)
      pick_app do |app|
        title "Signing you in..."
        show_spinner

        app.__send__(name, *args, options[:public_key]) do |host, command|
          hide_spinner

          Ninefold::Runner.new(host, command)
        end
      end
    end

    def show_spinner
      @brutus ||= Ninefold::Brutus.new
      @brutus.show
    end

    def hide_spinner
      @brutus.hide
    end
  end
end
