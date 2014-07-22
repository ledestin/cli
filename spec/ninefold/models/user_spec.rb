require "spec_helper"

describe 'Ninefold::User' do

  let(:token) { SecureRandom.hex }
  let(:host)  { Ninefold::Host.new }
  let(:user)  { Ninefold::User.new('nikolay', token) }

  before do
    allow(user).to receive(:host).and_return(host)
  end

  context "#initialize" do
    it "assigns the name" do
      expect(user.name).to eq('nikolay')
    end

    it "assigns the user token" do
      expect(user.token).to eq(token)
    end
  end

  context "#signed_in?" do
    it "returns true if the user has a security token" do
      user.token = token
      expect(user).to be_signed_in
    end

    it "returns false if there is no sicurity token" do
      user.token = nil
      expect(user).not_to be_signed_in
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
        expect(user.name).to eq("nikolay")
      end

      it "signs in the user if it receives a token" do
        user.signin('nikolay', 'password')
        expect(user).to be_signed_in
      end

      it "saves the credentials" do
        expect(user).to receive(:save)
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
        expect(user.name).to eq(nil)
      end

      it "doesn't sign the user in" do
        user.signin("nikolay", "wrong-password")
        expect(user).not_to be_signed_in
      end

      it "doesn't attempt to save the user's credentials" do
        expect(user).not_to receive(:save)
        user.signin("nikolay", "wrong-password")
      end
    end
  end

  context "Netrc interactions" do
    let(:token_store) { Ninefold::Token }

    context ".find" do
      context "with existing token" do
        before { allow(token_store).to receive(:find).and_return(['nikolay', token]) }
        before { @user = Ninefold::User.find }

        it { expect(@user).to be_a(Ninefold::User) }
        it { expect(@user.name).to eq('nikolay') }
        it { expect(@user.token).to eq(token) }
      end

      context "with missing token" do
        before { allow(token_store).to receive(:find).and_return(nil) }
        before { @user = Ninefold::User.find }

        it { expect(@user).to be_a(Ninefold::User) }
        it { expect(@user.name).to be_nil }
        it { expect(@user.token).to be_nil }
      end

      context "with ENV['AUTH_TOKEN']" do
        before { allow(token_store).to receive(:find).and_return(nil) }
        before { ENV['AUTH_TOKEN'] = token }
        before { @user = Ninefold::User.find }
        after { ENV['AUTH_TOKEN'] = nil }

        it { expect(@user).to be_a(Ninefold::User) }
        it { expect(@user.name).to eq(nil) }
        it { expect(@user.token).to eq(token) }
      end
    end


    context "#save" do
      it "saves the netrc data when there is a username and a token" do
        expect(token_store).to receive(:save).with('nikolay', token)
        user.save
      end
    end

    context "#delete" do
      it "removes the data from the netrc entry" do
        expect(token_store).to receive(:clear)
        user.delete
      end
    end
  end
end
