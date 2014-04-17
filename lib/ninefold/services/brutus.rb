# -*- encoding: utf-8 -*-

module Ninefold
  class Brutus
    SPRITES = [
      %Q{
                (___)     \e[33m☀︎\e[0m
          """""" . ‟
        |" """""/ ⁃
         "||""||  "    \e[31m✿\e[0m
      \e[32m"'‟"'‟"'""'‟"'‟"'""'‟"'‟"'\e[0m

      }, %Q{
                (___)     \e[33m☀︎\e[0m
          """""" . ‟
        |" """""/ _
         "||""||  "    \e[31m✿\e[0m
      \e[32m"'‟"'‟"'""'‟"'‟"'""'‟"'‟"'\e[0m

      }, %Q{
                          \e[33m☀︎\e[0m
          """"""(___)
        /" """"" . ‟
         "||""||  ⁃    \e[31m✿\e[0m
      \e[32m"'‟"'‟"'""'‟"'‟"'""'‟"'‟"'\e[0m

      }, %Q{
                          \e[33m☀︎\e[0m
          """"""(___)
        |" """"" . ‟
         "||""||  -    \e[31m✿\e[0m
      \e[32m"'‟"'‟"'""'‟"'‟"'""'‟"'‟"'\e[0m

      }
    ]

    def self.say(text)
      text = text.gsub('\n', "\n").split("\n").map(&:strip)
      maxl = text.map{|s| s.size }.max
      maxl = maxl < 20 ? maxl % 2 == 1 ? 21 : 20 : maxl
      size = 14 # brutus mouth offset

      text = text.map do |line|
        puts line.center(maxl).inspect + ": #{line.center(maxl).length}, #{maxl}"
        " | #{line.center(maxl)} |"
      end

      text = [
        "  #{'-' * (maxl + 2)}",
        text.join("\n"),
        "  #{'-' * size} #{'-' * (maxl - size + 1)}",
        "  #{' ' * size}V"
      ]

      text = "\e[35m#{text.join("\n")}\e[0m"

      puts text + SPRITES[0].gsub("\n      ", "\n").gsub(/\s*\Z/, '')
    end

    def initialize
      @munch_0 = sprite(0)
      @munch_1 = sprite(1)
      @bites_0 = sprite(2)
      @bites_1 = sprite(3)

      @sprites = [@munch_0, @munch_1, @munch_0, @munch_1, @bites_0, @bites_1]
    end

    def show
      @spinner = Thread.new { chill }
    end

    def hide
      return if ! @spinner
      @spinner.kill

      if @i != nil
        move_caret_back
        print_blank_canvas
        move_caret_back

        @i = nil
      end
    end

    def chill
      @i = 0;

      print_blank_canvas

      while true
        @i = 0 if ! @sprites[@i]

        print(@sprites[@i]); @i += 1

        sleep 0.5
      end
    end

  protected

    def print(sprite)
      move_caret_back
      STDOUT.print sprite
    end

    def print_blank_canvas
      STDOUT.print (" " * 40 + "\n") * height
    end

    def move_caret_back
      STDOUT.print "\r\u001b[#{height}A"
    end

    def height
      @sprites[0].split("\n").size
    end

    def sprite(id)
      text   = SPRITES[id].gsub(/\A[ \t]*\n/, '').gsub(/\n[ \t]*\Z/, '')
      indent = text.scan(/^[ \t]*(?=\S)/).min.size || 0
      text.gsub(/^[ \t]{#{indent}}/, '').gsub("\n", " " * 40 + "\n")
    end
  end
end
