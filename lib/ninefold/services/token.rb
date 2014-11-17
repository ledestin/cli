require "netrc"

module Ninefold
  class Token
    class << self
      def find(host_name=nil)
        if params = netrc[host_name || host]
          [params.login, params.password]
        end
      end

      def save(username, password)
        if username && password
          netrc[host] = username, password
          netrc.save
        end
      end

      def clear
        netrc.delete host
        netrc.save
      end

      def netrc
        @netrc ||= Netrc.read(* [file].compact)
      end

      def file
        nil # use the ~/.netrc file by default
      end

      def host
        Ninefold::Preferences[:host]
      end
    end
  end
end
