module Ninefold
  class Key
    include Ninefold::Host::Access

    def self.all
      [].tap do |keys|
        Ninefold::Host.inst.get "/apps/#{app_id}/keys" do |response|
          response[:keys].each do |key|
            keys << new(key[:app_id], key[:name])
          end
        end
      end
    end

    def initialize(app_id, public_key=nil)

    end

    def save
      host.post "/apps/#{@app_id}/keys", public_key: @public_key
    end
  end
end
