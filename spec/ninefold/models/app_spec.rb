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

  context "commands" do
    let(:public_key) { "publickey==nikolay@ninefold.com" }

    before do
      Ninefold::Key.stub(:read => public_key)
      host.respond_to("/apps/#{app.id}/commands/#{command}", public_key: public_key)
        .with(:ok, {
          ssh: {
            user: 'nikolay',
            host: '123.123.123.123',
            port: '234'
          },
          command: response
        })
    end

    context "#console" do
      let(:command)  { :console }
      let(:response) { "nf console" }

      before do
        app.console do |host, command|
          @host    = host
          @command = command
        end
      end

      it "builds the correct host parameter" do
        @host.should == "nikolay@123.123.123.123 -p 234"
      end

      it "extracts the command correctly" do
        @command.should == "nf console"
      end
    end

    context "#dbconsole" do
      let(:command)  { :dbconsole }
      let(:response) { "nf dbconsole" }

      before do
        app.dbconsole do |host, command|
          @host    = host
          @command = command
        end
      end

      it "builds the correct host parameter" do
        @host.should == "nikolay@123.123.123.123 -p 234"
      end

      it "extracts the command correctly" do
        @command.should == "nf dbconsole"
      end
    end

    context "#rake" do
      let(:command)  { :rake }
      let(:response) { "nf rake" }

      before do
        app.rake 'routes' do |host, command|
          @host    = host
          @command = command
        end
      end

      it "builds the correct host parameter" do
        @host.should == "nikolay@123.123.123.123 -p 234"
      end

      it "extracts the command correctly" do
        @command.should == "nf rake routes"
      end
    end

  end

  context '#redeploy' do
    let(:params) { {} }

    before do
      host.respond_to("/apps/#{app.id}/redeploy", params).with(response_status)
    end

    context 'successfull' do
      let(:response_status) { :ok }

      context 'normal case' do
        it "schedules the redeploy" do
          app.redeploy do |success|
            success.should == true
          end
        end
      end

      context 'forced redeploy' do
        let(:params) { {force_redeploy: true} }

        it "shedules the redeploy" do
          app.redeploy true do |success|
            success.should == true
          end
        end
      end
    end

    context 'server side failure' do
      let(:response_status) { :fail }

      it "gets handled correctly" do
        app.redeploy do |success|
          success.should == false
        end
      end
    end
  end

end
