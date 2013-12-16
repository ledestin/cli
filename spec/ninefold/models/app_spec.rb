require "spec_helper"


describe "Ninefold::App" do
  let(:host) { Ninefold::Host.inst }
  let(:app) { Ninefold::App.new({"id" => 1, "name" => "App name"})}

  context "attributes" do
    it "bypasses the .id" do
      app.id.should == 1
    end

    it "bypasses the .name" do
      app.name.should == "App name"
    end
  end

  context ".load" do
    before do
      host.respond_to("/apps").with(:ok, {apps: [{id: 1, name: "App 1"}, {id: 2, name: "App 2"}]})

      Ninefold::App.load do |apps|
        @apps = apps
      end
    end

    it "loads the apps" do
      @apps.size.should == 2
      @apps.map(&:name).should == ["App 1", "App 2"]
    end
  end

  context "#console" do
    let(:public_key) { "publickey==nikolay@ninefold.com" }

    before do
      Ninefold::Key.stub(:read => public_key)
      host.respond_to("/apps/#{app.id}/console", public_key: public_key)
        .with(:ok, {
          ssh: {
            user: 'nikolay',
            host: '123.123.123.123',
            port: '234'
          },
          command: 'rm -rf /'
        })

      app.console do |host, command|
        @host    = host
        @command = command
      end
    end

    it "builds the correct host parameter" do
      @host.should == "nikolay@123.123.123.123 -p 234"
    end

    it "extracts the command correctly" do
      @command.should == "rm -rf /"
    end
  end

end
