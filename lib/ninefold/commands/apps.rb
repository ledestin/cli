module Ninefold
  class Ninefold::Command::Apps < Ninefold::Command
    desc "list", "list the apps registered to this account"
    def list
      title "Requesting the apps..."
    end

    desc "info", "print out info about an app"
    def info
      title "Getting the app info..."
    end

    desc "redeploy", "trigger the app redeployment"
    def redeploy
      title "Redeploying..."
    end
  end
end
