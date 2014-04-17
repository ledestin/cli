module Ninefold
  class Command::Brutus < Ninefold::Command
    desc "say smth smth...", "make Brutus say stuff"
    def say(*stuff)
      Ninefold::Brutus.new.say stuff.join(" ")
    end

    desc "chew", "watch Brutus chewing the grass"
    def chew
      puts "\n"
      Ninefold::Brutus.new.chew
      sleep 60
    end
  end
end
