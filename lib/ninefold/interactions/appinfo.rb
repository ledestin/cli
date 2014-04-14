module Ninefold
  class Interaction::Appinfo < Ninefold::Interaction
    def run(app)
      title "Getting the app info..."
      show_spinner

      app.fetch do
        hide_spinner

        app.attributes.each do |key, value|
          display_key = (key == 'deployed_sha' ? 'Deployed SHA' : key.capitalize)
          puts "#{display_key.ljust(15)} #{value}"
        end
      end
    end
  end
end
