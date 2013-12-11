module Ninefold
  class CLI < Ninefold::Command
    command_alias signin:  'user:signin'
    command_alias signout: 'user:signout'
    command_alias whoami:  'user:whoami'

    desc "user SUBCOMMAND", "manage user credentials"
    subcommand "user", Ninefold::Command::User

    desc "keys SUBCOMMAND", "manage your SSH keys"
    subcommand "keys", Ninefold::Command::Keys

    desc "apps SUBCOMMAND", "manage your apps"
    subcommand "apps", Ninefold::Command::Apps

    desc "brutus SUBCOMMAND", "make Brutus do things"
    subcommand "brutus", Ninefold::Command::Brutus
  end
end
