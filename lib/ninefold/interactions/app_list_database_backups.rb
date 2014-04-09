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
            puts " - #{backup}"
          end
          puts "\n"
        end
      end
    end
  end
end
