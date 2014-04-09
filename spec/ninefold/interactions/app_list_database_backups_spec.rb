require "spec_helper"

describe Ninefold::Interaction::AppListDatabaseBackups do

  let(:output)  { Ninefold::Spec::Output.new }
  let(:input)   { Ninefold::Spec::Input.new }
  let(:user)    { Ninefold::Spec::User.new }
  let(:prefs)   { {} }

  let(:database_list) { Ninefold::Interaction::AppListDatabaseBackups.new(output, input, user, prefs) }

  let(:app) { double(Ninefold::App, :id => 99) }

  let(:database_backup) { double(Ninefold::DatabaseBackup) }

  before do
    Ninefold::DatabaseBackup.stub(:new).and_return(database_backup)
  end

  context "with no backups" do
    before do
      Ninefold::DatabaseBackup.should_receive(:list).and_yield([])
    end

    it "works" do
      expect(database_list).to receive(:alert)
      database_list.run(app)
    end
  end

  context "with backups" do
    let(:backup) { double(Ninefold::DatabaseBackup, :to_s => "blah") }

    before do
      Ninefold::DatabaseBackup.should_receive(:list).and_yield([backup])
    end

    it "works" do
      Ninefold::Interaction::AppListDatabaseBackups.any_instance.stub(:puts)
      expect(backup).to receive(:to_s)
      database_list.run(app)
    end
  end


end