require "spec_helper"


describe "Ninefold::App" do
  let(:host)  { Ninefold::Host.inst }
  let(:attrs) { {"id" => 1, "name" => "App name"} }
  let(:app)   { Ninefold::App.new(attrs)}

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

  context '#attributes' do
    it "returns the apps attributes" do
      app.attributes.should == attrs
    end
  end

  context '#fetch' do
    let(:app_details) { {"id" => 123, "name" => "App name", "repo" => "git://github.com/nikolay/theosom.git"} }

    before do
      host.respond_to("/apps/#{app.id}").with(:ok, {app: app_details})
    end

    it "it assigns the new data" do
      app.fetch
      app.attributes.should == app_details
    end

    it "calls back once loaded" do
      @called = false
      app.fetch{ @called = true }
      @called.should == true
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

  context '#deploy_status' do
    let(:deploy_status) { "running" }

    before do
      host.respond_to("/apps/#{app.id}/deploy_status").with(:ok, status: deploy_status)
    end

    it "gets the deploy status and yields it in the callback" do
      @status = nil

      app.deploy_status do |status|
        @status = status
      end

      @status.should == deploy_status
    end
  end

end
