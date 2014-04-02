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
  end
end
