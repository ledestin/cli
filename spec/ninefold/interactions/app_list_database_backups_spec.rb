require "spec_helper"

describe Ninefold::Interaction::AppListDatabaseBackups do
  include_context "ui tests"

  let(:ui_class) { Ninefold::Interaction::AppListDatabaseBackups }
  let(:app) { double(Ninefold::App, :id => 99) }
  let(:backup) { double(Ninefold::DatabaseBackup, :to_s => "blah") }
  let(:backups) { [backup] }

  before do
    allow(Ninefold::DatabaseBackup).to receive(:new).and_return(backup)
    expect(Ninefold::DatabaseBackup).to receive(:list).and_yield(backups)
  end

  it "renders the backups list" do
    expect(ui).to receive(:list).with(backups, anything)

    ui.run(app)
  end

end
