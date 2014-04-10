require "spec_helper"

describe Ninefold::Interaction::AppDownloadDatabaseBackup do

  let(:output)  { Ninefold::Spec::Output.new }
  let(:input)   { Ninefold::Spec::Input.new }
  let(:user)    { Ninefold::Spec::User.new }
  let(:prefs)   { {} }

  let(:database_download) { Ninefold::Interaction::AppDownloadDatabaseBackup.new(output, input, user, prefs) }

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
      expect(database_download).to receive(:alert)
      database_download.run(app)
    end
  end

  context "with backups" do
    let(:backup) { double(Ninefold::DatabaseBackup, :created_at => 'floa', :url => 'blah', :file_name => 'vtha') }

    before do
      Ninefold::DatabaseBackup.should_receive(:list).and_yield([backup])
      expect(database_download).to receive(:pick).and_return(backup)
    end

    it "works" do
      Ninefold::Interaction::AppDownloadDatabaseBackup.any_instance.stub(:puts)
      expect(database_download).to receive(:system).with("curl '#{backup.url}' > #{backup.file_name}")
      database_download.run(app)
    end
  end


end