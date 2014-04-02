# Runs stuff on remote hosts via ssh
require "shellwords"

module Ninefold
  class Tunel
    def initialize(app, public_key)
      @app        = app
      @public_key = Ninefold::Key.read(public_key)
    end

    def run(command, *args, &onload)
      get_details_for(command, *args) do |host, command|
        onload.call(host, command) if onload

        print  "\e[90mStarting the process, press ctrl+d when you're done:\e[0m\n"
        system "ssh -oStrictHostKeyChecking=no #{host} -t '#{command}'"
      end
    end

    def push(local_filename, remote_filename, host)
      host, port = host.match(/(.+?) -p (\d+)/).to_a.slice(1,2)

      print "\e[36mUploading #{local_filename} -> #{host.split('@').last}\e[0m\n"

      remote_filename = "#{host}:#{Shellwords.escape(remote_filename)}"
      local_filename  = Shellwords.escape(local_filename)

      system "scp -o stricthostkeychecking=no -P #{port} #{local_filename} #{remote_filename}"
    end

    def print(str)
      Ninefold::Stdio.print str
    end

  protected

    def host
      Ninefold::Host.inst
    end

    def get_details_for(command, *args, &block)
      get_credentials_for command do |ssh, command|
        host = "#{ssh['user']}@#{ssh['host']} -p #{ssh['port']}"
        block.call host, "#{command} #{args.join(" ")}".strip
      end
    end

    def get_credentials_for(command, &block)
      host.post "/apps/#{@app.id}/commands/#{command}", public_key: @public_key do |response|
        block.call response[:ssh] || {}, response[:command]
      end
    end
  end
end
