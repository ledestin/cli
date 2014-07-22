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

    def self.get_url(app, backup, &block)
      Ninefold::Host.inst.get "/apps/#{app.id}/database/backups/#{backup.id}" do |response|
        block.call response["backup"]["download_url"]
      end
    end

    def id
      attributes['id']
    end

    def size
      attributes["size"]
    end

    def type
      attributes["type"]
    end

    def created_at
      DateTime.iso8601(attributes["created_at"]).strftime "%Y-%m-%d %H:%M"
    end

    def file_name
      "#{attributes['created_at'].gsub(/[^\d\.]+/,'-').split('.')[0]}.tar.gz"
    end

    def to_s
      "#{created_at} - (#{type}, #{size})"
    end
  end
end
