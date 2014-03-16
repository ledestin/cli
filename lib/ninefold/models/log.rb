module Ninefold
  class Log
    attr_accessor :app, :options

    def initialize(app, options)
      @app     = app
      @options = options
      @host    = Ninefold::Host.inst
    end

    def tailed?
      @options[:tail] == true
    end
  end
end
