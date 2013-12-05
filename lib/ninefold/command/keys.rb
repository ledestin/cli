module Ninefold
  class Command::Keys < Ninefold::Command
    desc "list", "Lists registered SSH keys"
    def list
    end

    desc "add", "Register your current machine public SSH key to ninefold"
    def push
    end

    desc "remove", "Remove a registered SSH key"
    def remove
    end
  end
end
