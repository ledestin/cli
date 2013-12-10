require 'spec_helper'

describe "Ninefold::Host" do
  let(:host) { Ninefold::Host.new("smth.com") }

  context '#initialize' do
    it "sets the host name" do
      host.name.should == "smth.com"
    end
  end

  context "#request" do
    let(:response) { host.request(:get, "/path") }

    before do
      host.respond_to("/path", {}).with(:ok, {})
    end

    it "returns an Ninefold::Host::Response object" do
      response.should be_a(Ninefold::Host::Response)
    end
  end

  describe "Ninefold::Host::Response" do
    let(:http_response) { double("Response", :success? => true, :body => "{}") }
    let(:response) { Ninefold::Host::Response.new(http_response) }

    context "#ok?" do
      it "returns true if the request is successful" do
        http_response.stub(:success? => true)
        response.ok?.should == true
      end

      it "returns false if the request is not successful" do
        http_response.stub(:success? => false)
        response.ok?.should == false
      end
    end

    context "#[]" do
      it "gives access the response body data" do
        http_response.stub(:body => '{"some" : "data"}')
        response["some"].should == "data"
      end

      it "provides indifirrent access" do
        http_response.stub(:body => '{"some" : "data"}')
        response[:some].should == "data"
      end

      it "doesn't crash if the data is not valid JSON" do
        http_response.stub(:body => 'something went wrong')
        response["some"].should == nil
      end
    end
  end
end
