module Ninefold
  class Command::Db < Ninefold::Command
    desc "import FILENAME", "import a database dump"
    def import(filename)
      if File.exists?(filename)
        tmp_filename = "/tmp/db-import-#{Time.now.to_i}.sql"

        run_app_command :dbimport, tmp_filename do |tonel, host|
          tonel.push filename, tmp_filename, host
        end
      else
        error "Could not find a file named: #{filename}"
      end
    end

    desc "backups", "list the database backups for this app"
    def backups
      pick_app do |app|
        interaction :app_list_database_backups, app
      end
    end

    desc "backup", "create a database backup"
    def backup
      pick_app do |app|
        interaction :app_create_database_backup, app
      end
    end

    desc "download", "download a database backup"
    def download
      pick_app do |app|
        interaction :app_download_database_backup, app
      end
    end


  end
end
