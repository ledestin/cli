require "thor"
require "netrc"
require "ninefold/user"
require "ninefold/preferences"

module Ninefold
  class CLI < Thor
    desc "login", "Log in to Ninefold on this computer"
    def login
      say "Signing you in...", :yellow
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

  end
end
