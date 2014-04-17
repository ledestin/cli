module Ninefold
  class Interaction::Showwebhook < Ninefold::Interaction
    def run(webhook)
      show_spinner

      webhook.show do |webhook|
        hide_spinner
        puts "Service: #{webhook.service} URL: #{webhook.url}"
      end
    end
  end
end
