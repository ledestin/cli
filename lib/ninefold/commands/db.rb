require "shellwords"

module Ninefold
  class Command::Db < Ninefold::Command

    desc "console", "runs db console"
    def console
      run_app_command :dbconsole
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

    desc "restore", "restore from a database backup"
    def restore
      pick_backup do |backup, app|
        interaction :app_restore_database_backup, app, backup
      end
    end

    desc "download", "download a database backup"
    def download
      pick_backup do |backup, app|
        title "Requesting the backup download url..."
        Ninefold::DatabaseBackup.get_url(app, backup) do |download_url|
          if `which wget`.size < 1
            say "We couldn't find 'wget' in your system to download the backup\nPlease download the following url with any web-browser instead\n#{download_url}"
          else
            title "Downloading backup -> #{backup.file_name}"
            system "wget -nv -O '#{backup.file_name}' '#{download_url}'"
            say "DONE", :green
          end
        end
      end
    end

    desc "import FILENAME", "import a database dump"
    def import(filename)
      if File.exists?(filename)
        tmp_filename = "/tmp/db-import-#{Time.now.to_i}.tar.gz"

        run_app_command :dbimport, tmp_filename do |tonel, host|
          tonel.push filename, tmp_filename, host
        end
      else
        error "Could not find a file named: #{filename}"
      end
    end

  protected

    def pick_backup(&block)
      pick_app do |app|
        interaction :pickbackup, app do |backup|
          block.call(backup, app)
        end
      end
    end
  end
end
