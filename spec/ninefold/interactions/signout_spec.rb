require "spec_helper"

describe "Ninefold::Interaction::Signout" do
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
    Ninefold::Interaction::Signout.new(output, input, user, prefs)
  end

  it "deletes the user credentials if the user says 'y'" do
    input.on("Are you sure?") { "y" }

    user.should_receive(:delete)

    ui.run
  end

  it "doesn't touch the user if he said nope" do
    input.on("Are you sure?") { "nope" }

    user.should_not_receive(:delete)

    ui.run
  end

end
