module Ninefold
  class Interaction::AppCreateDatabaseBackup < Ninefold::Interaction
    def run(app)
      title "Scheduling the database backup ..."
      show_spinner

      Ninefold::DatabaseBackup.create(app) do |success|
        hide_spinner

        if success
          done "The backup was successfully scheduled. It should appear on the list of backups in a few minutes"
        else
          fail "Failed to schedule the backup"
        end
      end
    end
  end
end
