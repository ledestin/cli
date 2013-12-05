require "thor"

module Ninefold
  class Command < Thor

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
