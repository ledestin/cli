require "spec_helper"

describe Ninefold::DatabaseBackup do
  let(:host)              { Ninefold::Host.inst }
  let(:app)               { double(Ninefold::App, :id => 99) }
  let(:attrs)             { { 'id' => '123', 'created_at' => '2014-04-09T04:40:09', 'size' => '10KB' } }
  let(:database_backup)   { Ninefold::DatabaseBackup.new(attrs) }

  describe "attributes" do
    it "sets attrs" do
      expect(database_backup.created_at).to eq "2014-04-09 04:40"
    end

    it "id" do
      expect(database_backup.id).to eq '123'
    end

    it "file_name" do
      expect(database_backup.file_name).to eq "2014-04-09-04-40-09.tar.gz"
    end
  end

  describe "list" do
    let(:data)    { { backups: [attrs] } }

    before do
      host.respond_to('/apps/99/database/backups').with(:ok, data)

      Ninefold::DatabaseBackup.list(app) do |backups|
        @backups = backups
      end
    end

    it { expect(@backups.size).to eq 1 }
    it { expect(@backups.first.size).to eq "10KB" }
  end

  describe "create" do

    before do
      host.respond_to('/apps/99/database/backups').with(:ok, {})

      Ninefold::DatabaseBackup.create(app) do |success|
        @success = success
      end
    end

    it { expect(@success) }
  end

  describe "restore" do
    before do
      host.respond_to('/apps/99/database/backups/123/restore').with(:ok, {})

      Ninefold::DatabaseBackup.restore(app, database_backup) do |success|
        @success = success
      end
    end

    it { expect(@success) }
  end

  describe ".get_url" do
    before do
      host.respond_to('/apps/99/database/backups/123').with(:ok, {backup: {download_url: "dummy url"}})

      Ninefold::DatabaseBackup.get_url(app, database_backup) do |success|
        @success = success
      end
    end

    it { expect(@success) }
  end

end
