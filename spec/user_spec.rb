require "ninefold/user"

describe 'Ninefold::User' do
  let(:token) { SecureRandom.hex }
  let(:user) { Ninefold::User.new('username', token) }

  context "#initialize" do
    it "assigns the username" do
      user.username.should == 'username'
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
end
