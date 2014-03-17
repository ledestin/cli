module Ninefold
  class Interaction::Logstail < Ninefold::Interaction
    def run(log)
      title "Loading the logs"
      show_spinner

      log.fetch do |entries|
        hide_spinner
        entries.each { |e| print_entry(e) }

        if log.tailed?
          log.poll do |entry|
            print_entry(entry)
          end
        elsif entries.empty?
          say "No log entries found", :yellow
        end
      end
    end

    def print_entry(entry)
      metadata = "#{time(entry)}, #{host(entry)}, #{source(entry)} | "
      puts "#{metadata}#{message(entry, metadata)}"
    end

    def time(entry)
      "\e[35m#{entry.time.strftime("%Y/%m/%d %H:%M:%S")}\e[0m"
    end

    def host(entry)
      "\e[33m#{entry.host}\e[0m"
    end

    def source(entry)
      "\e[32m#{entry.source.ljust(10)}\e[0m"
    end

    def message(entry, metadata)
      offset = metadata.gsub(/\e\[\d+m/, "").size
      entry.message.gsub(/I, \[.*?\]  INFO -- :\s*/, "").gsub(/\n/, " \\ ")
    end
  end
end
