require "spec_helper"

describe "Ninefold::Environment" do
  let(:env) { { "NINEFOLD_TOKEN" => "some-token" } }
  let(:wrapper) { Ninefold::Environment.new("NINEFOLD", env) }

  it "looks up the name using the prefix" do
    expect(wrapper["TOKEN"]).to eq("some-token")
  end

  it "upcases the name" do
    expect(wrapper["token"]).to eq("some-token")
  end
end
