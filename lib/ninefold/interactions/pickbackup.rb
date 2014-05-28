module Ninefold
  class Interaction::Pickbackup < Ninefold::Interaction
    def run(app, &block)
      title "Requesting the database backups list ..."
      show_spinner

      Ninefold::DatabaseBackup.list(app) do |backups|
        hide_spinner

        if backups.empty?
          error "Apparently you don't have any backups for this app"
        else
          if backup = pick("Please pick the backup:", backups)
            block.call backup
          end
        end
      end
    end
  end
end
