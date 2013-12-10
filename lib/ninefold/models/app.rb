module Ninefold
  class App
    include Ninefold::Host::Access

    def self.all
      [].tap do |apps|
        Ninefold::Host.inst.get "/apps" do |response|
          response[:apps].each do |app|
            apps << new(app)
          end
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
