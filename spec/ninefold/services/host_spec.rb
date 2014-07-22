require 'spec_helper'

describe "Ninefold::Host" do
  let(:host) { Ninefold::Host.new("smth.com") }

  context '#initialize' do
    it "sets the host name" do
      expect(host.name).to eq("smth.com")
    end
  end

  context "#request" do
    let(:response) { host.request(:get, "/path") }

    before do
      host.respond_to("/path", {}).with(:ok, {})
    end

    it "returns an Ninefold::Host::Response object" do
      expect(response).to be_a(Ninefold::Host::Response)
    end
  end

  describe "Ninefold::Host::Response" do
    let(:http_response) { double("Response", :success? => true, :body => "{}") }
    let(:response) { Ninefold::Host::Response.new(http_response) }

    context "#ok?" do
      it "returns true if the request is successful" do
        allow(http_response).to receive(:success?).and_return(true)
        expect(response.ok?).to eq(true)
      end

      it "returns false if the request is not successful" do
        allow(http_response).to receive(:success?).and_return(false)
        expect(response.ok?).to eq(false)
      end
    end

    context "#[]" do
      it "gives access the response body data" do
        allow(http_response).to receive(:body).and_return('{"some" : "data"}')
        expect(response["some"]).to eq("data")
      end

      it "provides indifirrent access" do
        allow(http_response).to receive(:body).and_return('{"some" : "data"}')
        expect(response[:some]).to eq("data")
      end

      it "doesn't crash if the data is not valid JSON" do
        allow(http_response).to receive(:body).and_return('something went wrong')
        expect(response["some"]).to eq(nil)
      end
    end
  end
end
