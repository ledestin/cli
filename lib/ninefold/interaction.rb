module Ninefold
  class Interaction
    include Ninefold::Stdio

    def initialize(output, input, user, prefs)
      @output = output
      @input  = input
      @user   = user
      @prefs  = prefs
    end

    def start
      run
    rescue Ninefold::Host::AccessDenied => e
      error "Access denied"
    rescue Ninefold::Host::Unreachable => e
      error "Could not reach the host"
    end

    def run
      raise NotImplementedError
    end
  end

end
