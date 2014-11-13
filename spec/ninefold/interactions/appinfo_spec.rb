require "spec_helper"

describe Ninefold::Interaction::Appinfo do
  include_context "ui tests"

  let(:ui_class) { Ninefold::Interaction::Appinfo }
  let(:app_attrs) {
    {
      'id'                => '99',
      'name'              => "sample app",
      'repository_url'    => "https://github.com/sample.git",
      'public_url'        => "http://sampleapp123.ninefold-apps.com",
      'status'            =>  "running",
      'environment'       =>  "production",
      'last_deployment'   => {
        'id'       => "5",
        'sha'      => "LAST_SHA",
        'status'   => "error",
        'services' => [
          { 'name' => "redis",    'status' => "starting" },
          { 'name' => "web",      'status' => "starting" },
          { 'name' => "worker",   'status' => "starting" },
          { 'name' => "database", 'status' => "running"  }
        ]},
        'project_id' => "PROJECT_ID"
  }}
  let(:app) { double(Ninefold::App, attributes: app_attrs) }

  before do
    expect(app)
      .to receive(:fetch)
      .and_yield
  end

  it "displays only sha of the last deployment" do
    displays = [
      "Id              99",
      "Name            sample app",
      "Deployed SHA    LAST_SHA",
      "Repository url  https://github.com/sample.git",
      "Public url      http://sampleapp123.ninefold-apps.com",
      "Status          running",
      "Environment     production",
      "Project id      PROJECT_ID"
    ]

    displays.each do |str|
      expect_any_instance_of(Ninefold::Interaction::Appinfo)
        .to receive(:puts)
        .with(str)
    end

    ui.run(app)
  end
end
