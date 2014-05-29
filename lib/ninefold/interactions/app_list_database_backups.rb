module Ninefold
  class Interaction::AppListDatabaseBackups < Ninefold::Interaction
    def run(app)
      title "Listing database backups ..."
      show_spinner

      Ninefold::DatabaseBackup.list(app) do |backups|
        hide_spinner

        list backups, empty_message: "Apparently you don't have any backups for this app"
      end
    end
  end
end
