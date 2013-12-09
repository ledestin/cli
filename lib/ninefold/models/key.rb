module Ninefold
  class Key
    include Ninefold::Host::Access

    def initialize(app_id, public_key=nil)

    end

    def save
      host.post "/apps/#{@app_id}/keys", public_key: @public_key
    end
  end
end
