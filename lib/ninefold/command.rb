require "thor"

module Ninefold
  class Command < Thor

  protected
    def require_user
      error "Please sign in first" unless user.signed_in?
    end

    def title(text)
      say "#{text}\n", :magenta
    end

    def error(text)
      say "ERROR: #{text}", :red
      exit 0
    end

    def user
      @user ||= Ninefold::User.find
    end

    def host
      @host ||= Ninefold::Host.inst
    end

    def interaction(name, *args)
      Ninefold::Interaction.const_get(name.to_s.capitalize)
        .new(self, self, user, Ninefold::Preferences)
        .start(*args)
    end
  end
end
