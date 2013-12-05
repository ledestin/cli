module Ninefold
  class Brutus
    SPRITES = [
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
      text.gsub(/^[ \t]{#{indent - 2}}/, '').gsub("\n", " " * 40 + "\n")
    end
  end
end
