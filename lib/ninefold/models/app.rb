module Ninefold
  class App
    include Ninefold::Host::Access

    def self.load(&block)
      [].tap do |apps|
        Ninefold::Host.inst.get "/apps" do |response|
          # FIXME a temporary hack to support the transitional changes in the apps API
          loaded_apps = response[:apps] || response
          loaded_apps.each do |app|
            apps << new(app, old_api: !!response[:apps])
          end

          block.call(apps) if block_given?
        end
      end
    end

    attr_reader :attributes, :deployment_id

    def initialize(attributes={}, options={})
      @attributes = attributes
      @old_api    = options[:old_api]
    end

    def fetch(&block)
      host.get "/apps/#{id}" do |response|
        # FIXME a temporary hack to support the transitional changes in the apps API
        app = response[:app] ? response[:app] : response
        app.each do |key, value|
          @attributes[key.to_s] = value
        end

        block.call(self) if block_given?
      end
    end

    def method_missing(name, *args, &block)
      @attributes[name.to_s] || super
    end

    def redeploy(force=false, &block)
      # FIXME a temporary hack to support the transitional changes in the apps API
      method, url = @old_api ? [:get, "/apps/#{id}/redeploy"] : [:post, "/apps/#{id}/deployments"]

      host.__send__ method, url, force ? {force_redeploy: true} : {} do |response|
        block.call response.ok?
      end
    end

    def deploy_status(&block)
      # FIXME a temporary hack to support the transitional changes in the apps API
      url = @old_api ? "/apps/#{id}/deploy_status" : "/apps/#{id}/deployments/last"

      host.get url do |response|
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
