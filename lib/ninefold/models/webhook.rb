module Ninefold
  class Webhook
    include Ninefold::Host::Access

    attr_reader :service

    def initialize(app, service, url=nil)
      @app     = app
      @service = service
      @url     = url
    end

    def create(&block)
      host.post "/apps/#{@app.id}/webhooks", { webhook: { service: @service, url: @url }} do |response|
        block.call(response.ok? ? nil : response['error'])
      end
    end

    def delete(&block)
      host.delete "/apps/#{@app.id}/webhooks/#{@service}" do |response|
        block.call response.ok?
      end
    end

    def app_name
      @app.name
    end
  end
end
