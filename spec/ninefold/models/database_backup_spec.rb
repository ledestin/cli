require "spec_helper"

describe Ninefold::DatabaseBackup do
  let(:host)              { Ninefold::Host.inst }
  let(:app)               { double(Ninefold::App, :id => 99) }
  let(:attrs)             { { 'created_at' => '2014-04-09T04:40:09Z', 'size' => '10KB' } }
  let(:database_backup)   { Ninefold::DatabaseBackup.new(attrs) }

  describe "attributes" do
    it "sets attrs" do
      expect(database_backup.created_at).to eq attrs['created_at']
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

end