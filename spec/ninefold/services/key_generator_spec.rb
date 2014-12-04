require "spec_helper"

describe "Ninefold::KeyGenerator" do
  let(:ssh_key)  { double(:ssh_key, private_key: 'private key', ssh_public_key: 'public key str') }

  before do
    expect(SSHKey)
      .to receive(:generate)
      .once
      .and_return ssh_key
  end

  describe ".create" do

    it "saves generated ssh key set" do
      expect(File)
        .to receive(:new)
        .twice
        .and_return double(:file, write: true, close: true)

      expect(Ninefold::KeyGenerator.create('loc')).to eq ssh_key
    end

  end

  describe "#save" do
    let(:public_key_file)  { double :file, location: "~/.ssh/ninefold_id_rsa.pub", close: true }
    let(:private_key_file) { double :file, location: "~/.ssh/ninefold_id_rsa", close: true }

    before do
      allow(File)
        .to receive(:new)
        .with('loc', 'w')
        .and_return public_key_file

      allow(File)
        .to receive(:new)
        .with('loc', 'w', 0600)
        .and_return private_key_file
    end

    it "saves generated ssh key set" do
      expect(public_key_file).to receive(:write).with(ssh_key.ssh_public_key)
      expect(private_key_file).to receive(:write).with(ssh_key.private_key)

      expect(Ninefold::KeyGenerator.new('loc').save).to eq ssh_key
    end

  end
end
