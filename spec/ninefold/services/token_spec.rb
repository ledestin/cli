require "spec_helper"

describe "Ninefold::Token" do
  let(:netrc) { Netrc.read(Ninefold::Token.file) }
  let(:host)  { 'test.ninefold.com' }
  let(:token) { SecureRandom.hex }

  before do
    Ninefold::Token.stub(:host => host, :netrc => netrc)
  end

  context ".find" do
    it "returns username/token if they're in the Netrc file" do
      netrc[host] = "nikolay", token
      netrc.save

      Ninefold::Token.find.should == ["nikolay", token]
    end

    it "returns an empty array if there is no saved token" do
      netrc.delete host

      Ninefold::Token.find.should == nil
    end
  end

  context ".save" do
    before { netrc.delete host }

    it "saves the username/token when provided" do
      Ninefold::Token.save "nikolay", token

      netrc[host].should == ["nikolay", token]
    end

    it "doesn't crash when given nils" do
      Ninefold::Token.save(nil, nil)

      netrc[host].should == nil
    end
  end

  context ".clear" do
    it "clears the netrc saved data" do
      netrc[host] = "nikolay", token
      netrc.save

      Ninefold::Token.clear

      netrc[host].should == nil
    end
  end
end
