require "thor"

module Ninefold
  class Command < Thor

  private

    def user
      @user ||= Ninefold::User.find
    end

    def interaction(name)
      Ninefold::Interaction.const_get(name.to_s.capitalize)
        .new(self, self, user, Ninefold::Preferences)
        .run
    end
  end
end
