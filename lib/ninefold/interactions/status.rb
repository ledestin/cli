module Ninefold
  class Interaction::Status < Interaction

    def run(app)
      title "Checking the deployment status..."
      show_spinner
      next_tick(app)
    end

    def tail_logs(app)
      hide_spinner
      if app.deploy_log
        app.deploy_log.fetch do |entries|
          entries.each { |e| logstail.print_entry(e) }
        end
      end
    end

    def logstail
      @logstail ||= Interaction::Logstail.new(@output, @input, @user, Ninefold::Preferences)
    end

    def next_tick(app)
      app.deploy_status do |status|
        case status
        when 'complete'
          hide_spinner
          done "Deployment is complete"
          break
        when 'running'
          tail_logs(app)
          sleep 3
          next_tick(app)
        else
          say "Whoops, apparently something went wrong", :red
        end
      end

    rescue Interrupt => e
      # that's okay
    end
  end
end
