# -*- encoding: utf-8 -*-

require "thor"

module Ninefold
  class Command < Thor
    class_option :sure, type: 'boolean', aliases: '-s', desc: "don't ask for confirmation"
    class_option :public_key, aliases: '-k', desc: "your public key location", default: "#{Dir.home}/.ssh/ninefold_id_rsa.pub"
    class_option :robot, type: 'boolean', aliases: '-q', desc: 'plain black and white mode without animations'
    class_option :magic, type: 'boolean', aliases: '-m', desc: 'add magic and rainbows'

    def self.start(*args)
      Ninefold::Stdio.robot_mode (ARGV & ['--no-brutus', '--robot']).size > 0

      super
    rescue Interrupt => e
      puts "\n" # do nothing if the user interrupted the programm
    rescue Ninefold::Key::Error, Ninefold::Host::Error => e
      error e.message
    rescue => e
      save_error_trace(e)
      error "Woops, something went wrong :(\nDid you try to update the ninefold gem?"
    end

    def self.error(text)
      Ninefold::Brutus.new.say("ERROR: #{text}", color: 31)
      exit 0
    end

    def self.save_error_trace(e)
      raise e if ENV['NINEFOLD_HOST'] != nil # development mode

      "/tmp/ninefold-cli-trace.txt".tap do |filename|
        File.write(filename, "#{e.message}\n\n------\n\n#{(e.backtrace || []).join("\n")}") rescue nil
      end
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
      klass = name.to_s.split('_').collect!{ |w| w.capitalize }.join
      Ninefold::Interaction.const_get(klass)
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

    def pick_app
      require_user

      if app = specified_app
        yield app
      else
        load_apps do |apps|

          if apps.count > 1
            if app = interaction(:pickapp, apps)
              save_app_in_dot_ninefold_file(app)
              yield app
            end
          elsif apps.count == 1
            say "▸ You have only one app (#{apps[0].name}) proceeding...", :yellow
            yield apps.first
          else
            puts "You don't have any apps"
          end
        end
      end
    end

    def run_app_command(name, *args, &block)
      pick_app do |app|
        tunnel = begin
                  Ninefold::Tunnel.new(app, options[:public_key])
                rescue Key::NotFound
                  title "Generating a ninefold ssh key set..."
                  Ninefold::Tunnel.new_with_key(app, options[:public_key])
                end

        title "Signing you onto the box..."
        show_spinner

        tunnel.run(name, *args) do |host, command|
          hide_spinner
          block.call(tunnel, host, command) if block
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

  private

  def specified_app
    app_from_dot_ninefold_file || app_from_env_id
  end
end
