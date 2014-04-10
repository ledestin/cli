module Ninefold

  class Interaction::AppDownloadDatabaseBackup < Ninefold::Interaction

    def pick_backup(app, &block)
      title "Download database backups ..."
      show_spinner

      Ninefold::DatabaseBackup.list(app) do |backups|
        hide_spinner

        if backups.empty?
          alert "Apparently you don't have any backups for this app"
        else
          if backup = pick("Please pick the backup:", backups)
            block.call backup
          end
        end

      end
    end
    def run(app)
      pick_backup(app) do |backup|
        title "Downloading backup #{backup.created_at}"
        puts ''
        system("curl '#{backup.url}' > #{backup.file_name}")
        puts ''
      end
    end
  end
end
