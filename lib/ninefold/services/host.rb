require "json"
require "faraday"

module Ninefold
  class Host
    def self.inst
      @inst ||= new(Ninefold::Preferences[:host])
    end

    module Access
      def host
        @host ||= Ninefold::Host.inst
      end
    end

    class AccessDenied  < StandardError; end
    class Unprocessable < StandardError; end
    class Unreachable   < StandardError; end

    DEFAULT_NAME = "portal.ninefold.com"
    API_VERSION  = "v1"

    attr_accessor :name, :version, :token

    def initialize(name=DEFAULT_NAME, version=API_VERSION)
      @name, @version = name, version
      @conn = Faraday.new(url: "#{@name.slice(0,9)=="localhost" ? "http" : "https"}://#{@name}")
    end

    def get(path, options={}, &block)
      request :get, path, options, &block
    end

    def post(path, options={}, &block)
      request :post, path, options, &block
    end

    def put(path, options={}, &block)
      request :put, path, options, &block
    end

    def patch(path, options={}, &block)
      request :patch, path, options, &block
    end

    def delete(path, options={}, &block)
      request :delete, path, options, &block
    end

    def request(method, path, params, &block)
      result = @conn.__send__ method, "/api/#{@version}#{path}", params do |req|
        req.headers['Authorization'] = @token if @token
      end

      raise AccessDenied  if result.status == 403
      raise Unprocessable if result.status  > 403

      Response.new(result).tap do |response|
        block.call(response) if block_given?
      end

    rescue Faraday::Error::ClientError => e
      raise Unreachable
    end

    class Response
      def initialize(http_response)
        @ok   = http_response.success?
        @data = JSON.parse(http_response.body) rescue {}
      end

      def ok?
        @ok
      end

      def [](key)
        @data[key.to_s]
      end

      def to_h
        @data
      end
    end
  end
end
