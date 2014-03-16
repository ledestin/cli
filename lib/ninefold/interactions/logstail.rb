module Ninefold
  class Interaction::Logstail < Ninefold::Interaction
    def run(log)
      puts "Tailing the logs"
      puts log.inspect
    end
  end
end
