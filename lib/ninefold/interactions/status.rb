module Ninefold
  class Interaction::Status < Interaction
    def run(app)
      title "Redeploying your app..."
      show_spinner
      next_tick(app)
    end

    def next_tick(app)
      app.deploy_status do |status|
        case status
        when 'complete'
          hide_spinner
          done "Deployment is complete"
          break
        when 'running'
          sleep 1
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
