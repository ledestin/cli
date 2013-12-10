module Ninefold
  class Ninefold::Command::Apps < Ninefold::Command
    desc "list", "list the apps registered to this account"
    def list
      require_user

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
      require_user

      load_apps do |apps|
        app = interaction(:pickapp, apps)

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

    desc "redeploy", "trigger the app redeployment"
    def redeploy
      require_user

      title "Redeploying..."
    end

  protected

    def load_apps(&block)
      title "Requesting your apps list..."
      brutus = Ninefold::Brutus.new
      brutus.show

      host.get "/apps" do |response|
        brutus.hide
        block.call response[:apps].map{ |hash| Ninefold::App.new(hash) }
      end
    end
  end
end
