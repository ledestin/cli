require "spec_helper"

describe Ninefold::Interaction::AppListDatabaseBackups do
  include_context "ui tests"

  let(:ui_class) { Ninefold::Interaction::AppListDatabaseBackups }
  let(:app) { double(Ninefold::App, :id => 99) }
  let(:backup) { double(Ninefold::DatabaseBackup, :to_s => "blah") }

  before do
    Ninefold::DatabaseBackup.stub(:new).and_return(backup)
    Ninefold::DatabaseBackup.should_receive(:list).and_yield(backups)
  end

  context "with no backups" do
    let(:backups) { [] }

    it "works" do
      expect(ui).to receive(:alert)
      ui.run(app)
    end
  end

  context "with backups" do
    let(:backups) { [backup] }

    it "works" do
      expect(backup).to receive(:to_s)
      ui.run(app)
    end
  end


end
