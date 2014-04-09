require "thor"

module Ninefold
  class Command < Thor
    class_option :sure, type: 'boolean', aliases: '-s', desc: "don't ask for confirmation"
    class_option :public_key, aliases: '-k', desc: "your public key location", default: "~/.ssh/id_rsa.pub"
    class_option :robot, type: 'boolean', aliases: '-q', desc: 'plain black and white mode without animations'

    def self.start(*args)
      Ninefold::Stdio.robot_mode (ARGV & ['--no-brutus', '--robot']).size > 0

      super
    rescue Interrupt => e
      puts "\n" # do nothing if the user interrupted the programm
    rescue Ninefold::Host::NotFound => e
      error "Server returned 404. Record is not found"
    rescue Ninefold::Host::AccessDenied => e
      error "Access denied"
    rescue Ninefold::Host::UnprocessableEntity => e
      error e
    rescue Ninefold::Host::Unprocessable => e
      error "Something went wrong on the other side"
    rescue Ninefold::Host::Unreachable => e
      error "Could not reach the host"
    rescue Ninefold::Key::NotFound => e
      error "Could not locate your public key (~/.ssh/id_rsa.pub)"
    end

    def self.error(text)
      Ninefold::Stdio.print("\e[31mERROR: #{text}\e[0m\n")
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
        @user = nil
      end
    end

    def title(text)
      Ninefold::Stdio.print("\e[36m#{text}\e[0m\n")
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

    def show_spinner
      return if Ninefold::Stdio.robot_mode

      @brutus ||= Ninefold::Brutus.new
      @brutus.show
    end

    def hide_spinner
      @brutus.hide if @brutus
    end

    def load_apps(&block)
      title "Requesting your apps list..."
      show_spinner

      Ninefold::App.load do |apps|
        hide_spinner

        block.call apps
      end
    end

    def pick_app(&block)
      require_user

      if app = app_from_dot_ninefold_file || app_from_env_id
        block.call app
      else
        load_apps do |apps|
          if app = interaction(:pickapp, apps)
            save_app_in_dot_ninefold_file(app)
            block.call app
          end
        end
      end
    end

    def run_app_command(name, *args, &block)
      pick_app do |app|
        title "Signing you in..."
        show_spinner

        tunel = Ninefold::Tunel.new(app, options[:public_key])
        tunel.run(name, *args) do |host, command|
          hide_spinner
          block.call(tunel, host, command) if block
        end
      end
    end

    def app_from_env_id
      Ninefold::App.new('id' => ENV['APP_ID']) if ENV['APP_ID']
    end

    def app_from_dot_ninefold_file
      return nil # FIXME disabled for now, until we figure what to do with it
      if config = Ninefold::Config.read("#{Dir.pwd}/.ninefold")
        Ninefold::App.new(config['app']) if config['app']
      end
    end

    def save_app_in_dot_ninefold_file(app)
      return nil # FIXME disabled for now, until we figure what to do with it
      if app.repo == current_rails_app_git_url
        Ninefold::Config.new("#{Dir.pwd}/.ninefold").write(app: app.attributes)
      end
    end

    def current_rails_app_git_url
      marker_files  = ["Gemfile.lock", ".git/config", "app/controllers/application_controller.rb"]
      its_rails_app = marker_files.map { |f| File.exists?("#{Dir.pwd}/#{f}") }.all?

      if its_rails_app
        git_config = Ninefold::Config.read("#{Dir.pwd}/.git/config")
        git_config.each do |group, params|
          params.each do |key, value|
            return value if key == 'url'
          end
        end
      end
    end
  end
end
