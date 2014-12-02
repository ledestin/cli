module Ninefold
  class Key
    class Error    < StandardError; end
    class NotFound < Error; end

    def self.read(location)
      new File.expand_path(location)
    end

    def self.create(app_id, location)
      Ninefold::KeyGenerator.create location
    end

    attr_reader :data, :id_file, :pub_file

    def initialize(location)
      @id_file, @pub_file = locate_keys_at(location)

      @data = File.read(location).gsub(/\s*\n\s*/, '').strip
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
