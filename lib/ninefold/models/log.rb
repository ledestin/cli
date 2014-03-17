require "cgi"

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

    def fetch(&callback)
      @host.get "/apps/#{@app.id}/logs?#{query_params}" do |response|
        entries = response[:logs].map{|attrs| Entry.new(attrs) }
        yield entries if block_given?
      end
    end

    def query_params
      params = {
        from:   @options[:from],
        to:     @options[:to],
        host:   @options[:host],
        source: @options[:source],
        search: @options[:search]
      }.reject! { |_,v| v == nil }

      params.each{ |k,v| params[k] = v.utc.strftime("%FT%T.%LZ") if v.is_a?(Time) }
      params.map { |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&")
    end

    class Entry
      attr_reader :attributes

      def initialize(attributes)
        @attributes = attributes
        @attributes['time'] = DateTime.parse(@attributes['time']).to_time if @attributes['time'].is_a?(String)
      end

      def method_missing(name, *args, &block)
        @attributes[name.to_s] || super
      end
    end
  end
end
