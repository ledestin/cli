require "thor"

module Ninefold
  class Command < Thor

    def self.start(*args)
      super
    rescue Interrupt => e
      puts "\n" # do nothing if the user interrupted the programm
    rescue Ninefold::Host::AccessDenied => e
      error "Access denied"
    rescue Ninefold::Host::Unprocessable => e
      error "Something went wrong on the other side"
    rescue Ninefold::Host::Unreachable => e
      error "Could not reach the host"
    rescue Ninefold::Key::NotFound => e
      error "Could not locate your public key (~/.ssh/id_rsa.pub)"
    end

    def self.error(text)
      puts "\e[31mERROR: #{text}\e[0m"
      exit 0
    end

    def self.command_alias(map)
      map.each do |name, command|
        desc name.to_s, "shortcut for #{command}"
        define_method name do |*args|
          invoke "ninefold:command:#{command}", args
        end
      end
    end

  protected
    def require_user
      if ! user.signed_in?
        invoke 'ninefold:command:user:signin'
      end
    end

    def title(text)
      say "#{text}\n", :cyan
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

    def interaction(name, *args, &block)
      Ninefold::Interaction.const_get(name.to_s.capitalize)
        .new(self, self, user, Ninefold::Preferences)
        .run(*args, &block)
    end
  end
end
