module Ninefold
  class Interaction::Addwebhook < Ninefold::Interaction
    def run(webhook)
      title "Setting the #{webhook.service} webhook url for #{webhook.app_name}"
      show_spinner

      webhook.create do |error|
        hide_spinner
        puts "We have successfully created your webhook" if !error
      end
    end
  end
end
