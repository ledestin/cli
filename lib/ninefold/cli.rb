require "thor"
require "netrc"
require "ninefold"

module Ninefold
  class CLI < Thor
    desc "login", "Log in to Ninefold on this computer"
    def login
      if user.signed_in?
        say "Already signed in as #{user.name}\n", :magenta
      else
        say "Please, sign in\n", :magenta
        interaction.signin
      end
    end

    desc "console", "Run the rails console on your apps"
    def console
      login if ! user.signed_in?
    end

  private

    def user
      @user ||= begin
        netrc = Netrc.read # (prefs['netrc_filename'])
        Ninefold::User.new *netrc['portal.ninefold.com']
      end
    end

    def prefs
      @prefs ||= Ninefold::Preferences.new({}, {}, {})
    end

    def interaction
      @interaction = Ninefold::Interaction.new(self, self, user, prefs)
    end

  end
end
