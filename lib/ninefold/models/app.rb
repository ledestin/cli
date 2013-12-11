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

    def to_s
      "##{id} #{name}"
    end
  end
end
