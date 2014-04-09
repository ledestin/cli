module Ninefold
  class Ninefold::Command::DatabaseBackup < Ninefold::Command
    desc "list", "list the databases apps for this app"
    def list
      pick_app do |app|
        interaction :app_list_database_backups, app
      end
    end

    desc "create", "create a database backup app"
    def create
      pick_app do |app|
        interaction :app_create_database_backup, app
      end
    end

  end
end
