require "spec_helper"


describe "Ninefold::App" do
  let(:host)  { Ninefold::Host.inst }
  let(:attrs) { {"id" => 1, "name" => "App name"} }
  let(:app)   { Ninefold::App.new(attrs)}

  context "attributes" do
    it "bypasses the .id" do
      expect(app.id).to eq(1)
    end

    it "bypasses the .name" do
      expect(app.name).to eq("App name")
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
      expect(@apps.size).to eq(2)
      expect(@apps.map(&:name)).to eq(["App 1", "App 2"])
    end
  end

  context '#attributes' do
    it "returns the apps attributes" do
      expect(app.attributes).to eq(attrs)
    end
  end

  context '#fetch' do
    let(:app_details) { {"id" => 123, "name" => "App name", "repo" => "git://github.com/nikolay/theosom.git"} }

    before do
      host.respond_to("/apps/#{app.id}").with(:ok, {app: app_details})
    end

    it "it assigns the new data" do
      app.fetch
      expect(app.attributes).to eq(app_details)
    end

    it "calls back once loaded" do
      @called = false
      app.fetch{ @called = true }
      expect(@called).to eq(true)
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
            expect(success).to eq(true)
          end
        end
      end

      context 'forced redeploy' do
        let(:params) { {force_redeploy: true} }

        it "shedules the redeploy" do
          app.redeploy true do |success|
            expect(success).to eq(true)
          end
        end
      end
    end

    context 'server side failure' do
      let(:response_status) { :fail }

      it "gets handled correctly" do
        app.redeploy do |success|
          expect(success).to eq(false)
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

      expect(@status).to eq(deploy_status)
    end
  end

end
