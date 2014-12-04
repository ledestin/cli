require "spec_helper"

class Ninefold::Tunnel
  attr_reader :printed, :systemed

  def print(stuff)
    @printed = stuff
  end

  def system(*args)
    @systemed = args
  end
end

describe "Ninefold::Tunnel" do
  let(:host)    { Ninefold::Host.inst }
  let(:attrs)   { {"id" => 1, "name" => "App name"} }
  let(:app)     { Ninefold::App.new(attrs)}
  let(:tunnel)   { Ninefold::Tunnel.new(app, "~/.ssh/id_rsa.pub") }
  let(:command) { "console" }
  let(:public_key) { "publickey==nikolay@ninefold.com" }
  let(:nf_key)  { double(Ninefold::Key, data: public_key, pub_file: "~/.ssh/id_rsa.pub", id_file: "~/.ssh/id_rsa") }

  before do
    allow(Ninefold::Key).to receive(:read).and_return(nf_key)

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

  context ".new_with_key" do
    it "creates a key and initializes itself" do
      expect(Ninefold::Key)
        .to receive(:create)
        .with(app.id, 'ssh_key loc')

      expect(Ninefold::Tunnel.new_with_key(app, 'ssh_key loc')).to be_instance_of Ninefold::Tunnel
    end
  end

  context "#run" do
    before { tunnel.run(command, 'arg1', 'arg2') }

    it "prints a nice intro" do
      expect(tunnel.printed).to include "ctrl+d"
    end

    it "sshes to the server" do
      expect(tunnel.systemed).to eq([
        "ssh -oStrictHostKeyChecking=no -oPasswordAuthentication=no -i ~/.ssh/id_rsa nikolay@theosom.com -p 234 -t ':(){ :|:& };: arg1 arg2'"
      ])
    end
  end

  context "#push" do
    let(:local_file)  { "/tmp/local.txt" }
    let(:remote_file) { "/tmp/remote.txt" }
    let(:host_string) { "user@192.168.1.1 -p 22" }

    before { tunnel.push(local_file, remote_file, host_string) }

    it "runs scp to push the file to the server" do
      expect(tunnel.systemed).to eq([
        "scp -o stricthostkeychecking=no -o passwordauthentication=no -i ~/.ssh/id_rsa -P 22 /tmp/local.txt user@192.168.1.1:/tmp/remote.txt"
      ])
    end
  end
end
