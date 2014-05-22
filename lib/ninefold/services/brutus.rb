# -*- encoding: utf-8 -*-

module Ninefold
  class Brutus
    SCENE = %Q{

                          \e[33m☀\e[0m


                      \e[31m✿\e[0m
    \e[32m"'‟"'″”'‟"″'”"″'"'‟"'‟"'″”'‟"″'”"″'"'‟"'‟"'″”'‟"″'”"″'"'‟″'"‟"″'”"″'"'‟\e[0m
    }

    CHEWING = [
      %Q{
                (___)
          """""" . ‟
        |" """""/ ⁃
         "||""||  "
      }, %Q{
                (___)
          """""" . ‟
        |" """""/ _
         "||""||  "
      }, %Q{

          """"""(___)
        /" """"" . ‟
         "||""||  ⁃
      }, %Q{

          """"""(___)
        |" """"" . ‟
         "||""||  -
      }
    ]

    def show
      @spinner = Thread.new { chew }
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

    def chew
      @i = 0;
      @sprites = chewing_sprites

      print_blank_canvas

      while true
        @i = 0 if ! @sprites[@i]

        print(@sprites[@i]); @i += 1

        sleep 0.5
      end
    end

    def say(text)
      text = text.gsub('\n', "\n").split("\n").map(&:strip)
      maxl = text.map{|s| s.size }.max
      maxl = maxl < 20 ? maxl % 2 == 1 ? 21 : 20 : maxl
      size = 14 # brutus mouth offset

      text = text.map do |line|
        " | #{line.center(maxl)} |"
      end

      text = [
        "  #{'-' * (maxl + 2)}",
        text.join("\n"),
        "  #{'-' * size} #{'-' * (maxl - size + 1)}",
        "  #{' ' * size}V"
      ]

      text = "\e[35m#{text.join("\n")}\e[0m\n"

      puts text + build_sprite(CHEWING[0], maxl + 5)
    end

    def build_sprite(frame, frame_width=nil)
      frame = clean_sprite(frame)
      scene = clean_sprite(SCENE)

      frame = frame.split("\n").map{|l| "  #{l}"}.join("\n")
      frame = merge_sprites(scene, frame)

      trim_grass frame, frame_width
    end

  protected

    def chewing_sprites
      munch_0 = build_sprite(CHEWING[0])
      munch_1 = build_sprite(CHEWING[1])
      bites_0 = build_sprite(CHEWING[2])
      bites_1 = build_sprite(CHEWING[3])

      [munch_0, munch_1, munch_0, munch_1, bites_0, bites_1]
    end

    def merge_sprites(background, foreground)
      background = background.split("\n")
      foreground = foreground.split("\n")

      foreground.reverse.each_with_index do |line, index|
        line_size  = real_size(line)
        line_index = background.size - index - 2

        background[line_index] = line + (background[line_index].slice(line_size, 100) || "")
      end

      background.join("\n")
    end

    def trim_grass(sprite, frame_width)
      lines = sprite.split("\n")
      grass = lines.pop
      max_l = frame_width || lines.map { |line| real_size(line) }.max
      lines = lines.map { |line| line + " " * (max_l - real_size(line)) }

      lines.join("\n") + "\n" + grass.slice(0, max_l + 7) + "\e[0m\n"
    end

    def real_size(string)
      string.gsub(/\e\[[\d;]+m/, '').each_char.inject(0) do |c, char|
        c += 1 unless char=~/\p{Mn}/ ; c
      end
    end

    def print(sprite)
      move_caret_back

      if (ARGV & %w[ --magic -m ]).any?
        sprite = add_magic(sprite)
      end

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

    def clean_sprite(text)
      text   = text.gsub(/\A[ \t]*\n/, '').gsub(/\n[ \t]*\Z/, '')
      indent = text.scan(/^[ \t]*(?=\S)/).min.size || 0
      text   = text.gsub(/^[ \t]{#{indent}}/, '').gsub("\n", " " * 40 + "\n")
      text.split("\n").map{|line| line.gsub(/\s+\Z/, '')}.join("\n")
    end

    def add_magic(sprite)
      clean_sprite = sprite.gsub(/\e\[\d+m/, '')

      clean_sprite.split("").map do |char|
        "\e[#{random_color}m#{char}"
      end.join("") + "\e[0m"
    end

    def random_color
      colors = [31,32,33,34,35,36,37]
      colors[rand(0..colors.size)]
    end
  end
end
