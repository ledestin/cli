module Ninefold
  class Interaction::Listapps < Ninefold::Interaction
    def run(apps)
      if apps.empty?
        alert "Apparently you don't have any active app on this account"
      else
        apps.each do |app|
          puts " - #{app}"
        end

        puts "\n"
      end
    end
  end
end
