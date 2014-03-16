require "spec_helper"

describe "Ninefold::Log" do
  let(:app) { Ninefold::App.new }
  let(:options) { {tail: true} }
  let(:log) { Ninefold::Log.new(app, options) }

  context "#initialize" do
    it "assigns the application reference" do
      expect(log.app).to eq app
    end

    it "assigns the options reference" do
      expect(log.options).to eq options
    end
  end

  context "#tailed?" do
    it "returns 'true' when options has :tail => true" do
      log.options = {tail: true}
      expect(log).to be_tailed
    end

    it "returns 'false' when options has :tail => false" do
      log.options = {tail: false}
      expect(log).not_to be_tailed
    end
  end
end
