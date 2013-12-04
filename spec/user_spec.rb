require "spec_helper"

describe 'Ninefold::User' do
  let(:token) { SecureRandom.hex }
  let(:user) { Ninefold::User.new('nikolay_the_osom', token) }

  context "#initialize" do
    it "assigns the name" do
      user.name.should == 'nikolay_the_osom'
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
