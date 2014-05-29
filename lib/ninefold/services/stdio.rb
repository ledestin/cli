# -*- encoding: utf-8 -*-

module Ninefold
  module Stdio

    def self.robot_mode(value=nil)
      if value == nil
        @robot_mode || ! STDOUT.tty?
      else
        @robot_mode = !!value
      end
    end

    def self.clean(text)
      text = text.gsub(/\e\[\d+m/, '') if robot_mode
      text
    end

    def self.print(text)
      Kernel.print clean(text)
    end

    def puts(text)
      Ninefold::Stdio.print(text + "\n")
    end

    def print(text)
      Ninefold::Stdio.print(text)
    end

    def say(text, *args)
      @output.say Ninefold::Stdio.clean(text), *args
    end

    def title(text)
      say "#{text}\n", :cyan
    end

    def ask(label, options={})
      # a quick fix until Thor with STDOUT.noecho things get released
      old_state = `stty -g` if options[:echo] == false
      `stty -echo` if options[:echo] == false

      result = @input.ask label, :cyan, options

      result

    ensure
      `stty #{old_state}` && say("\n") if options[:echo] == false
    end

    def error(msg)
      hide_spinner
      say "\nERROR: #{msg}", :red
    end

    def alert(msg)
      say msg, :yellow
    end

    def confirm(msg)
      ARGV.include?('--sure') || ARGV.include?('-s') || @input.yes?(msg, :cyan)
    end

    def pick(title, options)
      puts "\e[33m#{title}\e[0m \e[90m(use arrows and press Enter)\e[0m"

      puts "\n" * (options.size + 2)

      selected = 0

      print_options(options, selected)

      while true
        case ch = read_key
        when "\e[A" # UP
          selected -= 1
          selected = options.size - 1 if selected < 0
          print_options(options, selected)

        when "\e[B" # DOWN
          selected += 1
          selected = 0 if selected > options.size - 1
          print_options(options, selected)

        when "\r", "\n"   # ENTER
          return options[selected]

        when "\u0003", "\e" # Ctrl+C, ESC
          puts "\n"
          exit(0)

        #else puts "You pressed: #{ch.inspect}\n"
        end
      end
    end

    def print_options(options, selected=0)
      print "\r\e[#{options.size + 1}A"

      options.each_with_index do |option, i|
        print " \e[36m#{i == selected ? '☛' : ' '}\e[0m  #{option}\n"
      end

      print "\n"
    end

    def read_key
      old_state = `stty -g`
      `stty raw -echo`

      c = STDIN.getc.chr

      if c == "\e" # reading escape sequences
        extra_thread = Thread.new do
          c += STDIN.getc.chr + STDIN.getc.chr
        end
        extra_thread.join(0.001)
        extra_thread.kill
      end

      c

    ensure
      `stty #{old_state}`
    end

    def list(items, options={})
      say "\n"

      items.each do |item|
        say " • #{item}"
      end

      if items.size == 0
        alert options[:empty_message] || "Apparently the list is empty"
      end

      say "\n"
    end

    def done(text="Done")
      say "✔︎  #{text}", :green
    end

    def fail(text="Failed")
      say "✖︎  #{text}", :red
    end

    def show_spinner
      return if Ninefold::Stdio.robot_mode

      @spinner ||= Ninefold::Brutus.new
      @spinner.show
    end

    def hide_spinner
      @spinner.hide if @spinner
    end

    def with_spinner(&block)
      show_spinner
      yield
      hide_spinner
    end
  end
end
