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

    def method_missing(name, *args, &block)
      @options[name.to_s] || super
    end

    def console(public_key=nil, &block)
      run_app_command :console, public_key, &block
    end

    def dbconsole(public_key=nil, &block)
      run_app_command :dbconsole, public_key, &block
    end

    def rake(args, public_key=nil, &block)
      run_app_command :rake, public_key, args, &block
    end

    def to_s
      "##{id} #{name}"
    end

  protected

    def run_app_command(command, public_key, args=nil, &block)
      host.post "/apps/#{id}/commands/#{command}", public_key: Ninefold::Key.read(public_key) do |response|
        ssh  = response[:ssh] || {}
        host = "#{ssh['user']}@#{ssh['host']} -p #{ssh['port']}"

        block.call host, "#{response[:command]} #{args}".strip
      end
    end
  end
end
