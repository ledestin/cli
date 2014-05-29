module Ninefold
  class Interaction::AppListDatabaseBackups < Ninefold::Interaction
    def run(app)
      title "Listing database backups ..."
      show_spinner

      Ninefold::DatabaseBackup.list(app) do |backups|
        hide_spinner
        if backups.empty?
          alert "Apparently you don't have any backups for this app"
        else
          backups.each do |backup|
            say " - #{backup}"
          end
          say "\n"
        end
      end
    end
  end
end
