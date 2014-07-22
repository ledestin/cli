require "spec_helper"

describe "Ninefold::Token" do
  let(:netrc) { Netrc.read(Ninefold::Token.file) }
  let(:host)  { 'test.ninefold.com' }
  let(:token) { SecureRandom.hex }

  before do
    allow(Ninefold::Token).to receive(:host).and_return(host)
    allow(Ninefold::Token).to receive(:netrc).and_return(netrc)
  end

  context ".find" do
    it "returns username/token if they're in the Netrc file" do
      netrc[host] = "nikolay", token
      netrc.save

      expect(Ninefold::Token.find).to eq(["nikolay", token])
    end

    it "returns an empty array if there is no saved token" do
      netrc.delete host

      expect(Ninefold::Token.find).to eq(nil)
    end
  end

  context ".save" do
    before { netrc.delete host }

    it "saves the username/token when provided" do
      Ninefold::Token.save "nikolay", token

      expect(netrc[host]).to eq(["nikolay", token])
    end

    it "doesn't crash when given nils" do
      Ninefold::Token.save(nil, nil)

      expect(netrc[host]).to eq(nil)
    end
  end

  context ".clear" do
    it "clears the netrc saved data" do
      netrc[host] = "nikolay", token
      netrc.save

      Ninefold::Token.clear

      expect(netrc[host]).to eq(nil)
    end
  end
end
