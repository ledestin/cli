module Ninefold
  class Interaction::Addslackurl < Ninefold::Interaction
    def run(webhook)
      title "Setting the slack webhook url for #{webhook.app_name}"
      show_spinner

      webhook.create do |error|
        hide_spinner

        if !error
          puts "We have successfully created your webhook"
        else
          puts "Failure: #{error}"
        end
      end
    end
  end
end
