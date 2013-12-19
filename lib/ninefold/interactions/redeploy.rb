module Ninefold
  class Interaction::Redeploy < Ninefold::Interaction
    def run(app, force_redeploy)
      return unless confirm("Are you sure you want to redeploy this app?")

      title "Starting the redeployment..."

      app.redeploy force_redeploy do |success|
        if success
          say "Redeployment was successfully scheduled", :green
        else
          say "Redeployment failed :(", :red
        end
      end
    end
  end
end
