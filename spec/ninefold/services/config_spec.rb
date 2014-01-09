require 'spec_helper'

describe "Ninefold::Config" do
  let(:config_file) { "/tmp/.ninefold" }
  let(:config_data) { %Q{
    [one]
      num  = 0
      bool = true
      string = something
    [two "and a half"]
      key = value
  }}
  let(:config) {
    File.open(config_file, "w") {|f| f.write(config_data) }
    Ninefold::Config.new(config_file)
  }

  describe "new instance" do
    it "saves the filename" do
      config.filename.should == config_file
    end

    it "parses the data correctly" do
      config.params.should == {
        'one' => {
          'num'    => 0,
          'bool'   => true,
          'string' => 'something'
        },
        'two "and a half"' => {
          'key'    => 'value'
        }
      }
    end
  end

  describe "#[]" do
    it "returns the key values" do
      config['one'].should == {
        'num'    => 0,
        'bool'   => true,
        'string' => 'something'
      }
    end

    it "allows to assign new keys" do
      config['new'] = 'value'
      config['new'].should == 'value'
    end
  end

  describe "#write" do
    it "writes the flat config data into the file" do
      config.write({a: 1, b: 2, c: 3})
      File.read(config_file).should == "a = 1\nb = 2\nc = 3"
    end

    it "writes nested configs into the file" do
      config.write({a: {b: 2, c: 3}})
      File.read(config_file).should == "[a]\n  b = 2\n  c = 3"
    end
  end

  describe "#delete" do
    it "deletes the config file" do
      config.delete
      File.exists?(config_file).should == false
    end
  end

end
