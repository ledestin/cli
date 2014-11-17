module Ninefold
  class Key
    include Ninefold::Host::Access

    class Error    < StandardError; end
    class NotFound < Error; end

    def self.read(location=nil)
      new File.expand_path(location || "~/.ssh/id_rsa.pub")
    end

    attr_reader :data, :id_file, :pub_file

    def initialize(location, app_id=nil)
      @id_file, @pub_file = locate_keys_at(location)

      @data = File.read(location).gsub(/\s*\n\s*/, '').strip
    end

    def save
      host.post "/apps/#{@app_id}/keys", public_key: @public_key
    end

  private

    def locate_keys_at(location)
      pub_file = location
      id_file  = location.gsub(/\.pub$/, '')

      raise NotFound, "couldn't locate the public key file: #{pub_file}" if ! File.exists?(pub_file)
      raise NotFound, "couldn't locate the SSH ID file: #{id_file}" if ! File.exists?(id_file)

      [id_file, pub_file]
    end
  end
end
