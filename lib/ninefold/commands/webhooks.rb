module Ninefold
  class Ninefold::Command::Webhooks < Ninefold::Command
    SERVICES = ['slack']

    desc "create SERVICE URL", 'add service webhook url to the app.'
    def create(service, url)
      available_service(service) do
        pick_app do |app|
          interaction :addwebhook, Webhook.new(app, service.capitalize, url)
        end
      end
    end

    desc "delete SERVICE", "remove service webhook url from the app."
    def delete(service)
      available_service(service) do
        pick_app do |app|
          interaction :removewebhook, Webhook.new(app, service.capitalize)
        end
      end
    end

    desc "show SERVICE", "show service webhook url from the app."
    def show(service)
      available_service(service) do
        pick_app do |app|
          interaction :showwebhook, Webhook.new(app, service.capitalize)
        end
      end
    end

    private

    def available_service(service, &block)
      if SERVICES.include? service
        block.call
      else
        error "#{service} is an invalid Service. please select from available services: [#{SERVICES.join(',')}]"
      end
    end
  end
end
