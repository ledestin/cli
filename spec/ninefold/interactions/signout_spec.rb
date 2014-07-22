require "spec_helper"

describe "Ninefold::Interaction::Signout" do
  include_context "ui tests"

  let(:ui_class) { Ninefold::Interaction::Signout }

  it "deletes the user credentials if the user says 'y'" do
    input.on("Are you sure?") { "y" }

    expect(user).to receive(:delete)

    ui.run
  end

  it "doesn't touch the user if he said nope" do
    input.on("Are you sure?") { "nope" }

    expect(user).not_to receive(:delete)

    ui.run
  end

end
