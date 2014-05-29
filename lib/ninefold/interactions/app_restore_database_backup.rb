module Ninefold
  class Interaction::AppRestoreDatabaseBackup < Ninefold::Interaction
    def run(app, backup)
      title "Scheduling the database restore ..."
      show_spinner

      Ninefold::DatabaseBackup.restore(app, backup) do |success|
        hide_spinner

        if success
          done "The database restore was successfully scheduled. It should be done in a few minutes"
        else
          fail "Failed to schedule the database restore"
        end
      end
    end
  end
end
