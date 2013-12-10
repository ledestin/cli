require "thor"

module Ninefold
  class Command < Thor

  protected

    def title(text)
      say "#{text}\n", :magenta
    end

    def error(text)
      say "ERROR: #{text}", :red
    end

    def bsay(text)
      Ninefold::Brutus.say text
    end

    def user
      @user ||= Ninefold::User.find
    end

    def interaction(name)
      Ninefold::Interaction.const_get(name.to_s.capitalize)
        .new(self, self, user, Ninefold::Preferences)
        .start
    end
  end
end
