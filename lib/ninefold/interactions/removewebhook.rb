module Ninefold
  class Interaction::Removewebhook < Ninefold::Interaction
    def run(webhook)
      title "Removing #{webhook.service} webhook url for #{webhook.app_name}"
      show_spinner

      webhook.delete do |success|
        hide_spinner
        puts "We have successfully deleted your webhook" if success
      end
    end
  end
end
