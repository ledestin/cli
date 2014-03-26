require "spec_helper"

class Ninefold::Tunel
  attr_reader :printed, :systemed

  def print(stuff)
    @printed = stuff
  end

  def system(*args)
    @systemed = args
  end
end

describe "Ninefold::Tunel" do
  let(:host)    { Ninefold::Host.inst }
  let(:attrs)   { {"id" => 1, "name" => "App name"} }
  let(:app)     { Ninefold::App.new(attrs)}
  let(:tunel)   { Ninefold::Tunel.new(app, "~/.ssh/id_rsa.pub") }
  let(:command) { "console" }
  let(:public_key) { "publickey==nikolay@ninefold.com" }

  before do
    Ninefold::Key.stub(:read => public_key)
    host.respond_to("/apps/#{app.id}/commands/#{command}", public_key: public_key)
      .with(:ok, {
        ssh: {
          user: 'nikolay',
          host: 'theosom.com',
          port: '234'
        },
        command: ":(){ :|:& };:"
      })
  end

  context "#run" do
    before { tunel.run(command, 'arg1', 'arg2') }

    it "prints a nice intro" do
      tunel.printed.should include "ctrl+d"
    end

    it "sshes to the server" do
      tunel.systemed.should == [
        "ssh -oStrictHostKeyChecking=no nikolay@theosom.com -p 234 -t ':(){ :|:& };: arg1 arg2'"
      ]
    end
  end
end
