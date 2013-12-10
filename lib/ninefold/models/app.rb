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

    def initialize(options={})
      @options = options
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
      name
    end
  end
end
