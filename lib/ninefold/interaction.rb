module Ninefold
  class Interaction
    include Ninefold::Stdio

    def initialize(output, input, user, prefs)
      @output = output
      @input  = input
      @user   = user
      @prefs  = prefs
    end

    def run(*args, &block)
      raise NotImplementedError
    end
  end

end
