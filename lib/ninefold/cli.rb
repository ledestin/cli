module Ninefold
  class CLI < Ninefold::Command
    command_alias signin:    'user:signin'
    command_alias signout:   'user:signout'
    command_alias whoami:    'user:whoami'

    command_alias console:   'app:console'
    command_alias dbconsole: 'app:dbconsole'
    command_alias rake:      'app:rake'
    command_alias logs:      'app:logs'

    desc "user SUBCOMMAND", "manage user credentials"
    subcommand "user", Ninefold::Command::User

    # desc "keys SUBCOMMAND", "manage your SSH keys"
    # subcommand "keys", Ninefold::Command::Keys

    desc "app SUBCOMMAND", "manage your apps"
    subcommand "app", Ninefold::Command::App

    desc "db SUBCOMMAND", "manage your databases"
    subcommand "db", Ninefold::Command::Db

    desc "brutus SUBCOMMAND", "make Brutus do things"
    subcommand "brutus", Ninefold::Command::Brutus
  end
end
