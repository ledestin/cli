require 'spec_helper'

describe "Ninefold::Host" do
  let(:host) { Ninefold::Host.new("smth.com") }

  context '#initialize' do
    it "sets the host name" do
      host.name.should == "smth.com"
    end
  end

  describe "Ninefold::Host::Response" do
    let(:response) { Ninefold::Host::Response.new }

    it "responds to :ok?" do
      response.should respond_to(:ok?)
    end

    it "responds to :[]" do
      response.should respond_to(:[])
    end
  end
end
