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
    end

    class User
      def signin(username, password)
        @signed_in = @username == username && @password == password
      end

      def signed_in?
        @signed_in
      end

      def valid_credentials(username, password)
        @username = username
        @password = password
      end
    end
  end
end

describe "Ninefold::Interaction" do
  let(:output) do
    Ninefold::Spec::Output.new
  end

  let(:input) do
    Ninefold::Spec::Input.new
  end

  let(:user) do
    Ninefold::Spec::User.new
  end

  let(:prefs) { {} }

  let(:ui) do
    Ninefold::Interaction.new(output, input, user, prefs)
  end

  it "asks the user for an username and password" do
    input.on("Username:") { "wycats@example.com" }
    input.on("Password:") { "lol-e" }

    ui.signin
  end

  it "signs the user in if he enters a valid username and password" do
    user.valid_credentials "wycats@example.com", "lol-e"
    input.on("Username:") { "wycats@example.com" }
    input.on("Password:") { "lol-e" }

    ui.signin

    user.should be_signed_in
  end

  it "tries multiple times if the wrong information is provided" do
    user.valid_credentials "wycats@example.com", "lol-e"
    input.on("Username:") do |i|
      next "wycats@example.com" if i == 9
      "nope@example.com"
    end
    input.on("Password:") { "lol-e" }

    ui.signin

    user.should be_signed_in
  end

  it "fails if the wrong information is supplied 10 times" do
    user.valid_credentials "wycats@example.com", "lol-e"
    input.on("Username:") { "nope@example.com" }
    input.on("Password:") { "lol-e" }

    ui.signin

    user.should_not be_signed_in
  end
end
