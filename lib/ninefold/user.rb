require "netrc"

module Ninefold
  class User
    def self.netrc
      @netrc ||= Netrc.read(* [@netrc_filename].compact )
    end

    def self.for(host="portal.ninefold.com")
      new *netrc[host], host
    end

    def self.host
      @host
    end

    attr_accessor :name, :token, :host

    def initialize(name=nil, token=nil, host=nil)
      @name, @token, @host = name, token, host
    end

    def signed_in?
      !! @token
    end

    def signin(email, password)
      sleep 2 # do stuff
      []
    end

    def save
      return if ! @name || ! @token

      netrc = self.class.netrc
      netrc[@host] = @name, @token
      netrc.save
    end
  end
end
