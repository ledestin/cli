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
    before do
      user.verified = true
    end

    it "returns true if the user has a security token" do
      user.token = token
      user.should be_signed_in
    end

    it "returns false if there is no sicurity token" do
      user.token = nil
      user.should_not be_signed_in
    end
  end

  context "#verify" do
    context "token is valid on the server side" do
      before do
        host.respond_to("/tokens/verify", {token: token}).with(:ok, {})
      end

      it "returns 'true'" do
        user.verify.should == true
      end

      it "marks the user as verified" do
        user.verify
        user.should be_verified
      end
    end

    context "token is not valid anymore" do
      before do
        host.respond_to("/tokens/verify", {token: token}).with(:fail, {})
      end

      it "returns false" do
        user.verify.should == false
      end

      it "doesn't make the user verified" do
        user.verify
        user.should_not be_verified
      end
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
      let(:existing_host)     { 'existing.host.com'     }
      let(:non_existing_host) { 'non-existing.host.com' }

      before do
        netrc[existing_host] = 'nikolay', token
        netrc.save
      end

      context "with existing host" do
        before{ @user = Ninefold::User.for(existing_host) }

        it { @user.should be_a(Ninefold::User) }
        it { @user.name.should == 'nikolay' }
        it { @user.token.should == token }
      end

      context "with non-existing host" do
        before{ @user = Ninefold::User.for(non_existing_host) }

        it { @user.should be_a(Ninefold::User) }
        it { @user.name.should be_nil }
        it { @user.token.should be_nil }
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

    context "#delete" do
      before do
        netrc[host.name] = 'nikolay', token
        netrc.save
      end

      it "removes the data from the netrc entry" do
        user.delete
        netrc[host.name].should be_nil
      end
    end
  end
end
