require "date"

module Ninefold
  class Ninefold::Command::App < Ninefold::Command
    command_alias dbconsole: 'db:console'

    desc "list", "list the apps registered to this account"
    def list
      require_user

      load_apps do |apps|
        interaction :listapps, apps
      end
    end

    desc "info", "print out info about an app"
    def info
      pick_app do |app|
        interaction :appinfo, app
      end
    end

    desc "console", "run the rails console on an app"
    def console
      run_app_command :console
    end

    desc "rake", "run rake tasks in an app"
    def rake(name, *args)
      run_app_command :rake, ([name] + args).join(' ')
    end

    desc "logs", "access logs from your application"
    option :tail,   type: 'boolean', aliases: "-t", desc: "continuously tail the logs"
    option :host,   type: 'string',  aliases: "-H", desc: "specific host to get data of"
    option :logs,   type: 'string',  aliases: "-l", desc: "type of logs (rails/asset/bundler/cheflog/error/migration, etc)"
    option :search, type: 'string',  aliases: "-f", desc: "search keywords"
    option :from,   type: 'string',                 desc: "from datetime (default from the beginning of the day)"
    option :to,     type: 'string',                 desc: "to datetime (defaults to today)"
    def logs
      options_unfrozen = options.dup
      options_unfrozen[:from] = DateTime.parse(options[:from]) if options[:from]
      options_unfrozen[:to]   = DateTime.parse(options[:to])   if options[:to]

      pick_app do |app|
        interaction :logstail, Log.new(app, options_unfrozen)
      end

    rescue ArgumentError => e
      error e # datetime parsing error
    end

    desc "redeploy", "trigger the app redeployment"
    option :force, type: 'boolean', aliases: '-f', desc: "use the force Luke!"
    def redeploy
      pick_app do |app|
        interaction :redeploy, app, options[:force] do
          interaction :status, app
        end
      end
    end

    desc "redeploy_command", "print a redeploy command for CI"
    def redeploy_command
      pick_app do |app|
        puts "AUTH_TOKEN=#{user.token} APP_ID=#{app.id} ninefold app redeploy --robot --sure"
      end
    end

    desc "deploy_status", "check on an app's deployment status"
    def deploy_status
      pick_app do |app|
        interaction :status, app
      end
    end
  end
end
