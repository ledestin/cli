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

    attr_reader :options

    def initialize(options={})
      @options = options
    end

    def method_missing(name)
      @options[name.to_s]
    end

    def console(public_key=nil, &block)
      host.post "/apps/#{id}/console", public_key: Ninefold::Key.read(public_key) do |response|
        ssh  = response[:ssh] || {}
        host = "#{ssh['user']}@#{ssh['host']} -p #{ssh['port']}"

        block.call host, response[:command]
      end
    end

    def rake(public_key=nil, &block)
      host.post "/apps/#{id}/rake", public_key: Ninefold::Key.read(public_key) do |response|
        ssh  = response[:ssh] || {}
        host = "#{ssh['user']}@#{ssh['host']} -p #{ssh['port']}"

        block.call host, response[:command]
      end
    end

    def to_s
      "##{id} #{name}"
    end
  end
end
