module Ninefold
  class Interaction::Redeploy < Ninefold::Interaction
    def run(app, force_redeploy, &on_complete)
      return unless confirm("Are you sure you want to redeploy this app?")
      puts "\n"
      title "Starting the redeployment..."

      app.redeploy force_redeploy do |success|
        if success
          done "Redeployment was successfully scheduled"
          on_complete.call if block_given?
        else
          error "Redeployment failed :("
        end
      end
    end
  end
end
