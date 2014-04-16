module Ninefold
  class Interaction::AppCreateDatabaseBackup < Ninefold::Interaction
    def run(app)
      title "Creating database backup ..."
      show_spinner

      Ninefold::DatabaseBackup.create(app) do |success|
        hide_spinner

        if success
          puts "Backup complete for #{app.name}"
        else
          puts "Backup failed for #{app.name}"
        end
      end
    end
  end
end
