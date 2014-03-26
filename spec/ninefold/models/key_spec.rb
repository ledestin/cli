require "spec_helper"

describe "Ninefold::Key" do
  let(:key_file) { "#{Dir.home}/.ssh/id_rsa.pub" }

  context ".read" do
    it "returns the current public key as a string" do
      File.stub(:read).with(key_file).and_return("rsa key")
      Ninefold::Key.read.should == "rsa key"
    end

    it "removes new lines out of the key" do
      File.stub(:read).with(key_file).and_return("ssh-key stuff\nstuff my\n@email.com\n    ")
      Ninefold::Key.read.should == "ssh-key stuffstuff my@email.com"
    end

    it "raises Ninefold::Key::NotFound if public key file doesn't exist" do
      File.stub(:read).with(key_file).and_raise(Errno::ENOENT)

      -> {
        Ninefold::Key.read
      }.should raise_error(Ninefold::Key::NotFound)
    end

    it "lets you to read other key locations" do
      Ninefold::Key.read(__FILE__).should == File.read(__FILE__).gsub(/\s*\n\s*/, '').strip
    end
  end

end
