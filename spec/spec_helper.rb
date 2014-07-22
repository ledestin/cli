require "ninefold"
require "securerandom"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

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
