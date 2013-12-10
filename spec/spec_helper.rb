require "ninefold"
require "securerandom"

class Ninefold::Brutus
  def show
    # print nothing in tests
  end
end

Ninefold::Token.instance_eval do
  def file
    "/tmp/ninefold-cli-test.netrc"
  end
end

class Ninefold::Host

  def request(method, path, options={})
    find_response_for path, options
  end

  def find_response_for(path, options)
    request = (@requests || []).detect do |query|
      query.path == path && query.options.to_s == options.to_s
    end

    raise "Unexpected a request to path: #{path}, params: #{options} " if ! request

    Response.new(request)
  end

  def respond_to(path, options)
    Query.new(path, options).tap do |query|
      @requests ||= []
      @requests << query
    end
  end

  class Query
    attr_reader :path, :options, :status, :data

    def initialize(path, options)
      @path    = path
      @options = options
    end

    def with(status, data)
      @status = status
      @data   = data
    end

    def success?
      @status == :ok
    end

    def body
      @data.to_json
    end
  end
end

module Ninefold
  module Spec
    class Output
      def initialize
        @out = []
      end

      def say(string, color=nil)
        @out << [string, color]
      end
    end

    class Input
      attr_reader :asked

      def initialize
        @questions = {}
        @counts = Hash.new(-1)
        @asked = []
      end

      def on(name, &block)
        @questions[name] = block
      end

      def ask(name, *args)
        if @questions.include?(name)
          @asked << [name, args]
          @questions[name].call(@counts[name] += 1)
        else
          raise "The test tried to ask '#{name}' but you didn't handle it"
        end
      end

      def yes?(name, *args)
        if @questions.include?(name)
          @questions[name].call == 'y'
        else
          raise "The test tried to ask '#{name}' but you didn't handle it"
        end
      end
    end

    class User
      def signin(username, password)
        @signed_in = @username == username && @password == password
      end

      def signed_in?
        @signed_in
      end

      def delete
      end

      def valid_credentials(username, password)
        @username = username
        @password = password
      end
    end
  end
end
