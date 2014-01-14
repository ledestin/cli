require "spec_helper"

describe 'Ninefold::User' do

  let(:token) { SecureRandom.hex }
  let(:host)  { Ninefold::Host.new }
  let(:user)  { Ninefold::User.new('nikolay', token) }

  before do
    user.stub :host => host
  end

  context "#initialize" do
    it "assigns the name" do
      user.name.should == 'nikolay'
    end

    it "assigns the user token" do
      user.token.should == token
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
        host.respond_to("/tokens", session: {username: 'nikolay', password: 'password'})
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
        host.respond_to("/tokens", session: {username: "nikolay", password: "wrong-password"})
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
    let(:token_store) { Ninefold::Token }

    context ".find" do
      context "with existing token" do
        before { token_store.stub(:find => ['nikolay', token]) }
        before { @user = Ninefold::User.find }

        it { @user.should be_a(Ninefold::User) }
        it { @user.name.should == 'nikolay' }
        it { @user.token.should == token }
      end

      context "with missing token" do
        before { token_store.stub(:find => nil) }
        before { @user = Ninefold::User.find }

        it { @user.should be_a(Ninefold::User) }
        it { @user.name.should be_nil }
        it { @user.token.should be_nil }
      end

      context "with ENV['AUTH_TOKEN']" do
        before { token_store.stub(:find => nil) }
        before { ENV['AUTH_TOKEN'] = token }
        before { @user = Ninefold::User.find }
        after { ENV['AUTH_TOKEN'] = nil }

        it { @user.should be_a(Ninefold::User) }
        it { @user.name.should == nil }
        it { @user.token.should == token }
      end
    end


    context "#save" do
      it "saves the netrc data when there is a username and a token" do
        token_store.should_receive(:save).with('nikolay', token)
        user.save
      end
    end

    context "#delete" do
      it "removes the data from the netrc entry" do
        token_store.should_receive(:clear)
        user.delete
      end
    end
  end
end
