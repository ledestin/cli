require "date"

module Ninefold
  class Ninefold::Command::Webhooks < Ninefold::Command

    desc "create_slack URL", "add slack webhook url to the app"
    def create_slack(url)
      pick_app do |app|
        interaction :addSlackUrl, Webhook.new(app, 'Slack', url)
      end
    end

    desc "delete_slack", "remove slack webhook url from the app"
    def delete_slack
      pick_app do |app|
        interaction :removeSlackUrl, Webhook.new(app, 'Slack')
      end
    end
  end
end
