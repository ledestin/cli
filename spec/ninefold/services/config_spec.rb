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

  describe ".read" do
    it "returns a config instance if the file exists" do
      expect(Ninefold::Config.read(config.filename)).to be_a(Ninefold::Config)
    end

    it "returns nil if the file doesn't exists" do
      expect(Ninefold::Config.read("/non/existing/file")).to eq(nil)
    end
  end

  describe "new instance" do
    it "saves the filename" do
      expect(config.filename).to eq(config_file)
    end

    it "parses the data correctly" do
      expect(config.params).to eq({
        'one' => {
          'num'    => 0,
          'bool'   => true,
          'string' => 'something'
        },
        'two "and a half"' => {
          'key'    => 'value'
        }
      })
    end
  end

  describe "#[]" do
    it "returns the key values" do
      expect(config['one']).to eq({
        'num'    => 0,
        'bool'   => true,
        'string' => 'something'
      })
    end

    it "allows to assign new keys" do
      config['new'] = 'value'
      expect(config['new']).to eq('value')
    end
  end

  describe "#write" do
    it "writes the flat config data into the file" do
      config.write({a: 1, b: 2, c: 3})
      expect(File.read(config_file)).to eq("a = 1\nb = 2\nc = 3")
    end

    it "writes nested configs into the file" do
      config.write({a: {b: 2, c: 3}})
      expect(File.read(config_file)).to eq("[a]\n  b = 2\n  c = 3")
    end
  end

  describe "#delete" do
    it "deletes the config file" do
      config.delete
      expect(File.exists?(config_file)).to eq(false)
    end
  end

end
