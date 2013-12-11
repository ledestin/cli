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
      @options = {}.tap do |hash|
        options.each do |key, value|
          hash[key.to_sym] = value
        end
      end
    end

    def id
      @options[:id]
    end

    def name
      @options[:name]
    end

    def repo
      @options[:repo]
    end

    def to_s
      "##{id} #{name}"
    end
  end
end
