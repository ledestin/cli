module Ninefold
  class Interaction::Removeslackurl < Ninefold::Interaction
    def run(webhook)
      title "Removing slack webhook url for #{webhook.app_name}"
      show_spinner

      webhook.delete do |success|
        hide_spinner

        if success
          puts "We have successfully removed Slack webhook"
        else
          puts "The webhook doesn't exist"
        end
      end
    end
  end
end
