require "spec_helper"

describe "Ninefold::Key" do
  let(:key_file) { "#{Dir.home}/.ssh/id_rsa.pub" }

  context ".read" do
    it "returns the current public key as a string" do
      Ninefold::Key.read.should == File.read(key_file)
    end

    it "raises Ninefold::Key::NotFound if public key file doesn't exist" do
      File.stub(:read).with(key_file).and_raise(Errno::ENOENT)

      -> {
        Ninefold::Key.read
      }.should raise_error(Ninefold::Key::NotFound)
    end

    it "lets you to read other key locations" do
      Ninefold::Key.read(__FILE__).should == File.read(__FILE__)
    end
  end

end
