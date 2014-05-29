module Ninefold
  class DatabaseBackup
    include Ninefold::Host::Access

    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
    end

    def self.list(app, &block)
      [].tap do |backups|
        Ninefold::Host.inst.get "/apps/#{app.id}/database/backups" do |response|
          response[:backups].each do |backup|
            backups << DatabaseBackup.new(backup)
          end
          block.call backups
        end
      end
    end

    def self.create(app, &block)
      Ninefold::Host.inst.post "/apps/#{app.id}/database/backups" do |response|
        block.call response.ok?
      end
    end

    def self.restore(app, backup, &block)
      Ninefold::Host.inst.post "/apps/#{app.id}/database/backups/#{backup.id}/restore" do |response|
        block.call response.ok?
      end
    end

    def id
      attributes['id']
    end

    def file_name
      "#{created_at.gsub(':','-').gsub('+00:00','')}.tar.gz"
    end

    def created_at
      DateTime.iso8601(attributes["created_at"]).to_s
    end

    def size
      attributes["size"]
    end

    def url
      attributes["url"]
    end

    def to_s
      "#{created_at} (#{size})"
    end
  end
end
