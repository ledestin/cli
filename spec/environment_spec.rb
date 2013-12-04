require "spec_helper"

describe "Ninefold::Environment" do
  let(:env) { { "NINEFOLD_TOKEN" => "some-token" } }
  let(:wrapper) { Ninefold::Environment.new("NINEFOLD", env) }

  it "looks up the name using the prefix" do
    wrapper["TOKEN"].should == "some-token"
  end

  it "upcases the name" do
    wrapper["token"].should == "some-token"
  end
end
