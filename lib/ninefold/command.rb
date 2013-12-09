require "thor"

module Ninefold
  class Command < Thor

  private

    def user
      @user ||= Ninefold::User.for(prefs[:host])
    end

    def prefs
      Ninefold::Preferences
    end

    def interaction
      @interaction = Ninefold::Interaction.new(self, self, user, prefs)
    end
  end
end
