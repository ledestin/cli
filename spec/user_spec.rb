require "spec_helper"

describe 'Ninefold::User' do
  class BogusHost
    attr_accessor :name

    def initialize(name="bogus-host.ninefold.com")
      @name = name
    end

    def post(path, options={})
      find_response_for path, options
    end

    def find_response_for(path, options)
      request = @requests.detect do |query|
        query.path == path && query.options.to_s == options.to_s
      end

      raise "Expected a request to path: #{path}, params: #{options} " if ! request

      Response.new(request)
    end

    def respond_to(path, options)
      Query.new(path, options).tap do |query|
        @requests ||= []
        @requests << query
      end
    end

    class Response
      def initialize(query)
        @query = query
      end

      def ok?
        @query.status == :ok
      end

      def [](name)
        @query.data[name]
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
    end
  end

  let(:token) { SecureRandom.hex }
  let(:host) { BogusHost.new }
  let(:user) { Ninefold::User.new('nikolay', token, host) }

  context "#initialize" do
    it "assigns the name" do
      user.name.should == 'nikolay'
    end

    it "assigns the user token" do
      user.token.should == token
    end

    it "assigns the host" do
      user.host.should == host
    end
  end

  context "#signed_in?" do
    it "returns true if the user has a security token" do
      user.token = token
      user.should be_signed_in
    end

    it "returns false if there is no sicurity token" do
      user.token = nil
      user.should_not be_signed_in
    end
  end

  context "#signin" do
    before do
      user.name  = nil
      user.token = nil
    end

    context "with correct credentials" do
      before do
        host.respond_to("/tokens", {username: 'nikolay', password: 'password'})
          .with(:ok, {token: token})
      end

      it "sends a token request to the API" do
        user.signin('nikolay', 'password')
      end

      it "sets the user's name" do
        user.signin('nikolay', 'password')
        user.name.should == "nikolay"
      end

      it "signs in the user if it receives a token" do
        user.signin('nikolay', 'password')
        user.should be_signed_in
      end

      it "saves the credentials" do
        user.should_receive(:save)
        user.signin('nikolay', 'password')
      end
    end

    context "with incorrect credentials" do
      before do
        host.respond_to("/tokens", {username: "nikolay", password: "wrong-password"})
          .with(:failed, {no: "token"})
      end

      it "doesn't fail" do
        user.signin("nikolay", "wrong-password")
      end

      it "doesn't set the user's name" do
        user.signin("nikolay", "wrong-password")
        user.name.should == nil
      end

      it "doesn't sign the user in" do
        user.signin("nikolay", "wrong-password")
        user.should_not be_signed_in
      end

      it "doesn't attempt to save the user's credentials" do
        user.should_not_receive(:save)
        user.signin("nikolay", "wrong-password")
      end
    end
  end

  context "Netrc interactions" do
    let(:netrc) { Ninefold::User.netrc }

    context ".for" do
      let(:existing_host)     { BogusHost.new('existing.host.com')     }
      let(:non_existing_host) { BogusHost.new('non-existing.host.com') }

      before do
        netrc[existing_host.name] = 'nikolay', token
        netrc.save
      end

      context "with existing host" do
        subject(:user) { Ninefold::User.for(existing_host) }

        it { should be_a(Ninefold::User) }
        it { user.name.should == 'nikolay' }
        it { user.token.should == token }
      end

      context "with non-existing host" do
        subject(:user) { Ninefold::User.for(non_existing_host) }

        it { should be_a(Ninefold::User) }
        it { user.name.should be_nil }
        it { user.token.should be_nil }
      end
    end

    context "#save" do
      before do
        netrc.delete host.name

        user.name  = 'nikolay'
        user.token = token
      end

      it "saves the netrc data when there is a username and a token" do
        netrc.should_receive(:save)
        user.save
        netrc[host.name].should == ['nikolay', token]
      end

      it "does nothing when a username is missing" do
        user.name = nil
        netrc.should_not_receive(:save)
        user.save
      end

      it "does nothing when a token is missing" do
        user.token = nil
        netrc.should_not_receive(:save)
        user.save
      end
    end
  end
end
