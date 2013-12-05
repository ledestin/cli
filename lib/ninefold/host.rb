require "json"
require "faraday"

module Ninefold
  class Host
    DEFAULT_NAME = "portal.ninefold.com"
    API_VERSION  = "v1"

    attr_accessor :name, :token

    def initialize(name=DEFAULT_NAME, version=API_VERSION)
      @name, @version = name, version
      @http = Faraday.new(url: "https://#{@name}")
    end

    def get(path, options={})
      request :get, path, options
    end

    def post(path, options={})
      request :post, path, options
    end

    def put(path, options={})
      request :put, path, options
    end

    def patch(path, options={})
      request :patch, path, options
    end

    def delete(path, options={})
      request :delete, path, options
    end

    def request(method, path, params)
      result = @conn.__send__ method, "/api/#{@version}#{path}", params do |req|
        req.headers['Authorization'] = @token if @token
      end

      Response.new(result)
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
    end
  end
end
