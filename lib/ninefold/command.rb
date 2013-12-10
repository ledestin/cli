require "thor"

module Ninefold
  class Command < Thor

  private

    def user
      @user ||= Ninefold::User.find
    end

    def interaction
      @interaction = Ninefold::Interaction.new(self, self, user, Ninefold::Preferences)
    end
  end
end
