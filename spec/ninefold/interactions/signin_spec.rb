require "spec_helper"

describe "Ninefold::Interaction::Signin" do
  let(:output) do
    Ninefold::Spec::Output.new
  end

  let(:input) do
    Ninefold::Spec::Input.new
  end

  let(:user) do
    Ninefold::Spec::User.new
  end

  let(:prefs) { {} }

  let(:ui) do
    Ninefold::Interaction::Signin.new(output, input, user, prefs)
  end

  it "asks the user for an username and password" do
    input.on("Username:") { "wycats@example.com" }
    input.on("Password:") { "lol-e" }

    ui.run
  end

  it "signs the user in if he enters a valid username and password" do
    user.valid_credentials "wycats@example.com", "lol-e"
    input.on("Username:") { "wycats@example.com" }
    input.on("Password:") { "lol-e" }

    ui.run

    user.should be_signed_in
  end

  it "tries multiple times if the wrong information is provided" do
    user.valid_credentials "wycats@example.com", "lol-e"
    input.on("Username:") do |i|
      next "wycats@example.com" if i == 9
      "nope@example.com"
    end
    input.on("Password:") { "lol-e" }

    ui.run

    user.should be_signed_in
  end

  it "fails if the wrong information is supplied 10 times" do
    user.valid_credentials "wycats@example.com", "lol-e"
    input.on("Username:") { "nope@example.com" }
    input.on("Password:") { "lol-e" }

    ui.run

    user.should_not be_signed_in
  end
end
