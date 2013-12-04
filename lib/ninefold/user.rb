module Ninefold
  class User
    attr_accessor :name, :token

    def initialize(name=nil, token=nil)
      @name, @token = name, token
    end

    def signed_in?
      !! @token
    end

    def signin(email, password)
      sleep 2 # do stuff
      []
    end
  end
end
