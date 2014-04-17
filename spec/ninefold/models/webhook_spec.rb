require "spec_helper"

describe "Ninefold::Webhook" do
  let(:host)  { Ninefold::Host.inst }
  let(:attrs) { {"id" => 1, "name" => "App name"} }
  let(:app)   { Ninefold::App.new(attrs)}

  context '#create' do
    let(:service) { 'Slack' }
    let(:url)     { '/sample' }
    let(:params)  {{ webhook: { service: service, url: url } }}
    let(:webhook) { Ninefold::Webhook.new(app, service, url) }

    it "gets the succesful response and yields it in the callback" do
      host.respond_to("/apps/#{app.id}/webhooks", params).with(:ok)
      @error = nil

      webhook.create do |error|
        @error = error
      end

      @error.should be_nil
    end

    it "gets the succesful response and yields it in the callback" do
      host.respond_to("/apps/#{app.id}/webhooks", params).with(:error, error: 'validation failed')
      @error = nil

      webhook.create do |error|
        @error = error
      end

      @error.should == 'validation failed'
    end
  end

  context '#delete' do
    let(:service) { 'Slack' }
    let(:url)     { '/sample' }
    let(:params)  {{ webhook: { service: service, url: url } }}
    let(:webhook) { Ninefold::Webhook.new(app, service, url) }

    it "yields true in the callback when successful" do
      host.respond_to("/apps/#{app.id}/webhooks/#{service}").with(:ok)
      @success = nil

      webhook.delete do |success|
        @success = success
      end

      @success.should be_true
    end

    it "yields false in the callback when fails" do
      host.respond_to("/apps/#{app.id}/webhooks/#{service}").with(:error)
      @success = nil

      webhook.delete do |success|
        @success = success
      end

      @success.should be_false
    end
  end

  context '#show' do
    let(:service) { 'Slack' }
    let(:url)     { '/sample' }
    let(:webhook_details)  {{ 'webhook' => { 'service' => service, 'url' => url } }}
    let(:org_webhook) { Ninefold::Webhook.new(app, service) }

    it "assigns the new url" do
      host.respond_to("/apps/#{app.id}/webhooks/#{service}").with(:ok, webhook_details)
      org_webhook.url.should be_nil
      org_webhook.show
      org_webhook.url.should == url
    end

    it "errors when not found" do
      host.respond_to("/apps/#{app.id}/webhooks/#{service}").with(:fail)
      org_webhook.url.should be_nil
      org_webhook.show
      org_webhook.url.should be_nil
    end
  end
end
