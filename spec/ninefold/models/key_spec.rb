require "spec_helper"

describe "Ninefold::Key" do
  let(:key_file) { "~/.ssh/id_rsa.pub" }
  let(:key_data) { "rsa key data" }

  before { File.stub(:exists?).with("#{Dir.home}/.ssh/id_rsa").and_return(true) }
  before { File.stub(:exists?).with("#{Dir.home}/.ssh/id_rsa.pub").and_return(true) }
  before { File.stub(:read).with("#{Dir.home}/.ssh/id_rsa.pub").and_return(key_data) }

  describe ".read" do
    let(:key) { Ninefold::Key.read(key_file) }

    context "default key" do
      it "builds the key" do
        expect(key).to be_a Ninefold::Key
      end

      it "reads the data" do
        expect(key.data).to eq key_data
      end

      it "sets the public key location" do
        expect(key.pub_file).to eq "#{Dir.home}/.ssh/id_rsa.pub"
      end

      it "sets the ID file location" do
        expect(key.id_file).to eq "#{Dir.home}/.ssh/id_rsa"
      end
    end

    context "with dirty key formatting" do
      let(:key_data) { "ssh-key stuff\nstuff my\n@email.com\n    " }

      it "cleans up the new lines and trailing spaces" do
        expect(key.data).to eq "ssh-key stuffstuff my@email.com"
      end
    end

    context "missing files" do
      it "raises an error when the public key file is missing" do
        File.stub(:exists?).with("#{Dir.home}/.ssh/id_rsa.pub").and_return(false)
        expect { key.data }.to raise_error(Ninefold::Key::NotFound)
      end

      it "raises an error when the ID file is missing" do
        File.stub(:exists?).with("#{Dir.home}/.ssh/id_rsa").and_return(false)
        expect { key.data }.to raise_error(Ninefold::Key::NotFound)
      end
    end
  end

end
