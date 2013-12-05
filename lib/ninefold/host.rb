module Ninefold
  class Host
    DEFAULT_NAME = "portal.ninefold.com"

    attr_reader :name

    def initialize(name=DEFAULT_NAME)
      @name = name
    end

    def get(path, options={})
      Response.new
    end

    def post(path, options={})
      sleep 1
      Response.new
    end

    def put(path, options={})
      Response.new
    end

    def patch(path, options={})
      Response.new
    end

    def delete(path, options={})
      Response.new
    end

    class Response
      def initialize
      end

      def ok?
      end

      def [](key)
      end
    end
  end
end
