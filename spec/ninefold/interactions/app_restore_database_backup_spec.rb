require "spec_helper"

describe "Ninefold::Interaction::AppRestoreDatabaseBackup" do
  include_context "ui tests"

  let(:ui_class) { Ninefold::Interaction::AppRestoreDatabaseBackup }

  let(:app) { double(Ninefold::App, :id => 99) }
  let(:backup) { double(Ninefold::DatabaseBackup, :to_s => "blah") }
  let(:confirmation_message) { "Are you sure you want to restore from this backup?\nThis will eraze all data in your database!" }

  subject(:interact) { ui.run(app, backup) }

  before { input.on(confirmation_message) { answer } }


  context "when user agrees" do
    let(:answer) { 'y' }

    it "schedules the restore" do
      expect(Ninefold::DatabaseBackup).to receive(:restore).with(app, backup)
      interact
    end
  end

  context "user disagrees" do
    let(:answer) { 'nay!' }

    it "shouldn't kick the restore in" do
      expect(Ninefold::DatabaseBackup).not_to receive(:restore).with(app, backup)
      interact
    end
  end

end
