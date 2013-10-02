require "ninefold/environment"

describe "Ninefold::Environment" do
  let(:env) { { "NINEFOLD_TOKEN" => "some-token" } }
  let(:wrapper) { Ninefold::Environment.new("NINEFOLD", env) }

  it "uses the specified environment prefix" do
    wrapper["TOKEN"].should == "some-token"
  end

  it "upcases the environment key" do
    wrapper["token"].should == "some-token"
  end
end
