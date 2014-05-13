require "spec_helper"

describe "Ninefold::Log" do
  let(:app) { Ninefold::App.new("id" => "123") }
  let(:options) { {tail: true} }
  let(:host)  { Ninefold::Host.inst }
  let(:entry_attrs) { {"id" => "asdf123", "time" => Time.now, "host" => "my-host-132", "logs" => "rails", "message" => "Ohi there"} }
  let(:entry) { Ninefold::Log::Entry.new(entry_attrs) }

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

  context "#fetch" do
    let(:logs_url) { "/apps/#{app.id}/logs.json?tags=rails&search=love" }
    let(:query) { log.fetch }

    before { log.options = {search: "love", logs: "rails"} }
    before { host.respond_to(logs_url).with(:ok, {logs: [entry_attrs]}) }

    it "makes query to the host" do
      expect(host).to receive(:get).with(logs_url)
      query
    end

    context "entries" do
      let(:entries) { query && log.entries }

      it "is an array of one" do
        expect(entries).to be_an Array
      end

      it "has an instance of a log entry" do
        expect(entries[0]).to be_a Ninefold::Log::Entry
      end

      it "has the entry with correct properties" do
        expect(entries[0].attributes.reject{|k,v| k == "time"}).to eq entry_attrs.reject{|k,v| k == "time"}
      end
    end
  end

  context "#query_params" do
    it "merges options into a query string" do
      log.options = {logs: "rails", search: "love"}
      expect(log.query_params).to eq "tags=rails&search=love"
    end

    it "escapes the values" do
      log.options = {logs: "rails", search: "weird & stuff"}
      expect(log.query_params).to eq "tags=rails&search=weird+%26+stuff"
    end

    it "exports dates into JSON compatible format" do
      from = Time.now - 2000; to = Time.now + 2000
      log.options = {from: from, to: to, logs: "rails"}
      expect(log.query_params).to eq "from=#{CGI.escape(from.strftime("%FT%T.%LZ"))}&to=#{CGI.escape(to.strftime("%FT%T.%LZ"))}&tags=rails"
    end

    it "defaults the logs list to the default tags" do
      log.options = {}
      expect(log.query_params).to eq "tags=access%2Capache%2Casset%2Cbundler%2Ccheflog%2Cerror%2Cmigration%2Crails%2Cssl_request%2Csyslog%2Ctrigger"
    end
  end

  context "::Entry" do

    it "has the assigned attributes" do
      expect(entry.attributes).to eq entry_attrs
    end

    %w{id time host logs message}.each do |property|
      it "exposes #{property} as a method" do
        expect(entry.__send__(property)).to eq entry_attrs[property]
      end
    end

    it "parses time stamps from strings into dates" do
      time  = Time.now
      entry = Ninefold::Log::Entry.new("time" => time.utc.strftime("%FT%T.%LZ"))
      expect(entry.time).to be_a Time
      expect(entry.time.to_i / 10).to eq(time.to_i/10)
    end
  end
end
