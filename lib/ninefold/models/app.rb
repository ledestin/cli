module Ninefold
  class App
    include Ninefold::Host::Access

    def self.load(&block)
      [].tap do |apps|
        Ninefold::Host.inst.get "/apps" do |response|
          response[:apps].each do |app|
            apps << new(app)
          end

          block.call(apps) if block_given?
        end
      end
    end

    attr_reader :attributes, :deployment_id

    def initialize(attributes={})
      @attributes = attributes
    end

    def fetch(&block)
      host.get "/apps/#{id}" do |response|
        response[:app].each do |key, value|
          @attributes[key.to_s] = value
        end

        block.call(self) if block_given?
      end
    end

    def method_missing(name, *args, &block)
      @attributes[name.to_s] || super
    end

    def redeploy(force=false, &block)
      host.get "/apps/#{id}/redeploy", force ? {force_redeploy: true} : {} do |response|
        block.call response.ok?
      end
    end

    def deploy_status(&block)
      host.get "/apps/#{id}/deploy_status" do |response|
        @deployment_id = response['deployment_id']
        block.call response['status']
      end
    end

    def to_s
      "##{id} #{name}"
    end

    def deploy_log
      if deployment_id
        @log ||= Ninefold::Log.new(self, :logs => "checkpoint#{deployment_id}")
      end
    end
  end
end
