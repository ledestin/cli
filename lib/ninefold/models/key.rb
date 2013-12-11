module Ninefold
  class Key
    include Ninefold::Host::Access

    class NotFound < StandardError; end

    def self.read
      File.read("#{Dir.home}/.ssh/id_rsa.pub")
    rescue Errno::ENOENT => e
      raise NotFound
    end

    def initialize(app_id, public_key=nil)

    end

    def save
      host.post "/apps/#{@app_id}/keys", public_key: @public_key
    end
  end
end
