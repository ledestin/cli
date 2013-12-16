# Runs stuff on remote hosts via ssh
require "shellwords"

module Ninefold
  class Runner
    def initialize(host, command)
      print "\e[90mStarting the process, press ctrl+d when you're done:\e[0m\n"

      begin
        system "ssh -oStrictHostKeyChecking=no #{host} -t '#{command}'"
      rescue Interrupt => e
        print "\n\e[90mLater...\e[0m\n"
      end
    end
  end
end
