module Ninefold
  class User
    attr_accessor :username, :token

    def initialize(username=nil, token=nil)
      @username, @token = username, token
    end

    def signed_in?
      !! @token
    end
  end
end
