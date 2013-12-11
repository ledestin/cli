# Runs stuff on remote hosts via ssh
module Ninefold
  class Runner
    def initialize(host, command)
      print "\e[90mPress Ctrl+C when you're done:\e[0m\n\n"

      begin
        system "ssh", host, command
      rescue Interrupt => e
        print "\n\e[90mLater...\e[0m\n"
      end
    end
  end
end
