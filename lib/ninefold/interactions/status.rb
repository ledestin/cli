module Ninefold
  class Interaction::Status < Interaction

    def run(app)
      title "Checking the deployment status..."
      next_tick(app)
    end

    def tail_logs(app)
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
          done "Deployment is complete"
        when 'running'
          tail_logs(app)
          sleep 3
          next_tick(app)
        else
          fail "Whoops, apparently the redeployment has failed"
        end
      end
    end
  end
end
