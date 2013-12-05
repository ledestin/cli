require "thor"

module Ninefold
  class CLI < Thor
    desc "signin", "Log in to Ninefold on this computer"
    def signin
      if user.signed_in?
        say "Already signed in as #{user.name}\n", :magenta
      else
        say "Please, sign in\n", :magenta
        interaction.signin
      end
    end

    desc "console", "Run the rails console on your apps"
    def console
      signin unless user.signed_in?
    end

  private

    def user
      @user ||= Ninefold::User.for(host)
    end

    def host
      @host ||= Ninefold::Host.new(prefs[:host])
    end

    def prefs
      @prefs ||= Ninefold::Preferences.new({}, {}, {})
    end

    def interaction
      @interaction = Ninefold::Interaction.new(self, self, user, prefs)
    end

  end
end
