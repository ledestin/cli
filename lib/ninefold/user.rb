require "netrc"

module Ninefold
  class User
    include Ninefold::Host::Access

    def self.netrc
      @netrc ||= Netrc.read(* [@netrc_filename].compact )
    end

    def self.for(host_name)
      name, token = netrc[host_name]
      new name, token
    end

    attr_accessor :name, :token, :verified

    def initialize(name=nil, token=nil)
      @name, @token = name, token
    end

    def signed_in?
      @token != nil && verified?
    end

    def signin(username, password)
      response = host.post "/tokens", {username: username, password: password}

      if response.ok?
        @name     = username
        @token    = response[:token]
        @verified = true # coz it's a brand new token
        save
      end
    end

    def verified?
      @verified ? true : verify == true
    end

    def verify
      if ! @verified && @token != nil
        response = host.get "/tokens/verify", {token: @token}

        if response.ok?
          return @verified = true
        end
      end

      @verified = false
    end

    def save
      return if ! @name || ! @token

      netrc = self.class.netrc
      netrc[host.name] = @name, @token
      netrc.save
    end

    def delete
      self.class.netrc.delete host.name
    end
  end
end
