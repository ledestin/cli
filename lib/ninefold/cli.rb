module Ninefold
  class CLI < Ninefold::Command
    desc "signin", "Sign in to Ninefold on this computer"
    def signin
      if user.signed_in?
        title "Already signed in as #{user.name}"
      else
        title "Please, sign in"
        interaction(:signin)
      end
    end

    desc "signout", "Sign out from Ninefold on this computer"
    def signout
      if user.signed_in?
        interaction(:signout)
      else
        title "Not signed in yet"
      end
    end

    desc "whoami", "Print info about the current user"
    def whoami
      if user.signed_in?
        title "You're signed in as: #{user.name}"
      else
        title "You're not signed in"
      end
    end

    desc "console", "Run the rails console on your apps"
    def console
      signin unless user.signed_in?
    end

    desc "keys SUBCOMMAND ... ARGS", "manage your SSH keys"
    subcommand "keys", Ninefold::Command::Keys

    desc "apps SUBCOMMAND ... ARGS", "manage your apps"
    subcommand "apps", Ninefold::Command::Apps
  end
end
