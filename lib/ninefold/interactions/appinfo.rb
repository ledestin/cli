module Ninefold
  class Interaction::Appinfo < Ninefold::Interaction
    def run(app)
      title "Getting the app info..."
      show_spinner

      app.fetch do
        hide_spinner

        app.attributes.each do |key, value|
          puts "#{key.capitalize.ljust(9)} #{value}"
        end
      end
    end
  end
end
