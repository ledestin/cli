require "json"

module Ninefold
  # Preferences is a wrapper that allows preferences to be loaded from:
  #
  # * environment variables
  # * a local file
  # * a global file
  class Preferences
    def self.defaults
      dev_env = File.exists?("#{Dir.pwd}/ninefold.gemspec")

      {
        host: dev_env ? "localhost:3000" : "portal.ninefold.com"
      }
    end

    def self.[](key)
      @inst ||= new({}, defaults, Ninefold::Environment.new('NINEFOLD'))
      @inst[key]
    end


    # `pwd` and `home` must be Paths:
    #
    # * join: return a new Path relative to the path root
    # * exists?: return true if the location represented by the path exists on the file system
    # * read: if the Path represents a file, return its body
    #
    # The bootstrap code will return Pathnames for the current working directory and the home
    # directory, but tests can use other objects.
    def initialize(local, global, env)
      @local, @global, @env = local, global, env
    end

    def [](name)
      @env[name] || @local[name] || @global[name]
    end
  end
end
