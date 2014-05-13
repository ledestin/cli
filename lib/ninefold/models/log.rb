require "cgi"

module Ninefold
  class Log
    DEFAULT_LOGS = %w{access apache asset bundler cheflog error migration rails ssl_request syslog trigger}.join(",")

    attr_accessor :app, :options, :entries

    def initialize(app, options={})
      @app     = app
      @options = options
      @host    = Ninefold::Host.inst
    end

    def tailed?
      @options[:tail] == true
    end

    def add(entries)
      @entries   ||= []
      @entry_ids ||= []

      [].tap do |new_entries|
        entries.each do |entry|
          if ! @entry_ids.include?(entry["id"])
            @entry_ids << entry["id"]
            entry = Entry.new(entry)
            @entries << entry
            new_entries << entry
          end
        end
      end
    end

    def fetch(&callback)
      @host.get "/apps/#{@app.id}/logs.json?#{query_params}" do |response|
        new_entries = add(response[:logs])
        yield new_entries if block_given?
      end
    end

    def poll(timeout=3.0, &callback)
      @last_timestamp ||= Time.now - timeout
      @options[:from] = @last_timestamp

      fetch do |entries|
        entries.each do |entry|
          callback.call(entry)
        end

        sleep timeout
        poll timeout, &callback
      end
    end

    def query_params
      params = {
        from:   @options[:from],
        to:     @options[:to],
        hosts:  @options[:host],
        tags:   @options[:logs] || DEFAULT_LOGS,
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
