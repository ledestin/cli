module Ninefold
  class Command::User < Ninefold::Command
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
        title "You're signed in as"

        say "Username:  #{user.name}\nAuthToken: #{user.token}"
      else
        title "You're not signed in"
      end
    end
  end
end
