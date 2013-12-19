module Ninefold
  class Interaction::Listapps < Ninefold::Interaction
    def run(apps)
      if apps.empty?
        say "Apparently you don't have any active app on this account", :yellow
      else
        apps.each do |app|
          puts " - #{app}"
        end

        puts "\n"
      end
    end
  end
end
