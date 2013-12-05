require "netrc"

module Ninefold
  class User
    def self.netrc
      @netrc ||= Netrc.read(* [@netrc_filename].compact )
    end

    def self.for(host)
      name, token = netrc[host.name]
      new name, token, host
    end

    attr_accessor :name, :token, :host

    def initialize(name=nil, token=nil, host=nil)
      @name, @token, @host = name, token, host
    end

    def signed_in?
      !! @token
    end

    def signin(username, password)
      response = host.post "/tokens", {username: username, password: password}

      if response.ok?
        @name  = username
        @token = response[:token]
        save
      end
    end

    def save
      return if ! @name || ! @token

      netrc = self.class.netrc
      netrc[@host.name] = @name, @token
      netrc.save
    end

    def delete
      self.class.netrc.delete @host.name
    end
  end
end
