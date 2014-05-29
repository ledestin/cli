require "spec_helper"

describe "Ninefold::Interaction::Signout" do
  include_context "ui tests"

  let(:ui_class) { Ninefold::Interaction::Signout }

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
