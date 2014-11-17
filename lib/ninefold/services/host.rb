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

    class Error < StandardError
      def self.msg=(msg)
        @msg = msg
      end

      def self.msg
        @msg
      end

      def initialize(msg=nil)
        super msg || self.class.msg
      end
    end

    class NotFound < Error
      self.msg = "Server returned 404. Record is not found"
    end

    class AccessDenied < Error
      self.msg = "Access denied"
    end

    class Unprocessable < Error
      self.msg = "Something went wrong on the other side"
    end

    class Unreachable < Error
      self.msg = "Could not reach the host"
    end

    DEFAULT_NAME = "portal.ninefold.com"
    API_VERSION  = "v1"

    attr_accessor :name, :version, :token

    def initialize(name=DEFAULT_NAME, version=API_VERSION)
      @name, @version, @protocol = name, version, name.slice(0,9)=="localhost" ? "http" : "https"
      @conn =  Faraday.new(url: "#{@protocol}://#{@name}", :ssl => {:verify => false})
      @conn.basic_auth ENV['PASSWORD'], ENV['PASSWORD'] if ENV['PASSWORD']
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
      path = "#{path}.json" unless path.include?(".json")
      result = @conn.__send__ method, "/api/#{@version}#{path}", params do |req|
        req.headers['NFAuthToken'] = @token if @token
      end

      handle_http_errors result

      Response.new(result).tap do |response|
        block.call(response) if block_given?
      end

    rescue Faraday::Error::ClientError => e
      raise Unreachable
    end

    def handle_http_errors(result)
      message = JSON.parse(result.body)['messages'].first rescue nil

      case result.status
      when 404 then raise NotFound, message
      when 403 then raise AccessDenied, message
      when 422 then raise Unprocessable, message
      when 405..500 then raise Unprocessable, message
      end
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
        @data.is_a?(Hash) ? @data[key.to_s] : key.is_a?(Integer) ? @data[key] : nil
      end

      def each(&block)
        @data.each(&block)
      end

      def to_h
        @data
      end

      def to_a
        @data
      end
    end
  end
end
