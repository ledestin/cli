module Ninefold
  class Environment
    def initialize(prefix, env=ENV)
      @env, @prefix = env, prefix
    end

    def [](name)
      @env["#{@prefix}_#{name.upcase}"]
    end
  end
end
