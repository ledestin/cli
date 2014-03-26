# Runs stuff on remote hosts via ssh

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
