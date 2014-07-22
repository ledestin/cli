require "spec_helper"

describe "Ninefold::Preferences" do
  let(:local) { {} }
  let(:global) { {} }
  let(:env) { {} }
  let(:prefs) { Ninefold::Preferences.new(local, global, env) }
  let(:token) { SecureRandom.hex }

  it "starts by reading the preference out of an environment variable" do
    env["token"] = token
    expect(prefs["token"]).to eq(token)
  end

  it "reads the preference out of a local file" do
    local["token"] = token
    expect(prefs["token"]).to eq(token)
  end

  it "reads the preference out of a global file" do
    global["token"] = token
    expect(prefs["token"]).to eq(token)
  end

  it "prefers environment variables to local files" do
    env["token"] = token
    local["token"] = "lol"

    expect(prefs["token"]).to eq(token)
  end

  it "prefers environment variables to global files" do
    env["token"] = token
    global["token"] = "lol"

    expect(prefs["token"]).to eq(token)
  end

  it "prefers local files to global files" do
    local["token"] = token
    global["token"] = "lol"

    expect(prefs["token"]).to eq(token)
  end
end
