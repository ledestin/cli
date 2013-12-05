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

    def signin(email, password)
      response = host.post "/signin", {email: email, password: password}

      if response.ok?
        @name  = response[:name]
        @token = response[:token]
        save!
      end
    end

    def save!
      return if ! @name || ! @token

      netrc = self.class.netrc
      netrc[@host] = @name, @token
      netrc.save
    end
  end
end
