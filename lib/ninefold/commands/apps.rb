module Ninefold
  class Ninefold::Command::Apps < Ninefold::Command
    desc "list", "list the apps registered to this account"
    def list
      load_apps do |apps|
        interaction :listapps, apps
      end
    end

    desc "info", "print out info about an app"
    def info
      pick_app do |app|
        interaction :appinfo, app
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

    desc "redeploy", "trigger the app redeployment"
    option :force, type: 'boolean', aliases: '-f', desc: "use the force Luke!"
    def redeploy
      pick_app do |app|
        interaction :redeploy, app, options[:force]
      end
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
