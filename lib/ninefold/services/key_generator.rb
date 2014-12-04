require 'sshkey'

module Ninefold
  class KeyGenerator

    def self.create(location)
      new(location).save
    end

    def initialize(location)
      @location = location
    end

    def save
      # save public key file
      file = File.new(@location, "w")
      file.write(public_key)
      file.close

      # save private key file
      file = File.new(@location.gsub('.pub', ''), "w", 0600)
      file.write(private_key)
      file.close

      ssh_key
    end

    private

    def ssh_key
      @ssh_key ||= SSHKey.generate(
        comment:    "cli@ninefold.com",
        passphrase: "ninefold"
      )
    end

    def private_key
      ssh_key.private_key
    end

    def public_key
      ssh_key.ssh_public_key
    end

  end
end
