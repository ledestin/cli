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

    def created_at
      attributes["created_at"]
    end

    def size
      attributes["size"]
    end

    def to_s
      "#{created_at} (#{size})"
    end
  end
end
