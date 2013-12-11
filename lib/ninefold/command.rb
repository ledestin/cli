require "thor"

module Ninefold
  class Command < Thor

    def self.start(*args)
      super
    rescue Ninefold::Host::AccessDenied => e
      error "Access denied"
    rescue Ninefold::Host::Unprocessable => e
      error "Something went wron on the other side"
    rescue Ninefold::Host::Unreachable => e
      error "Could not reach the host"
    end

    def self.error(text)
      puts "\e[31mERROR: #{text}\e[0m"
      exit 0
    end

  protected
    def require_user
      error "Please sign in first" unless user.signed_in?
    end

    def title(text)
      say "#{text}\n", :magenta
    end

    def error(text)
      Ninefold::Command.error(text)
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
        .run(*args)
    end
  end
end
