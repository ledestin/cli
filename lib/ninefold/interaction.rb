module Ninefold
  class Interaction
    def initialize(output, input, user, prefs)
      @output = output
      @input  = input
      @user   = user
      @prefs  = prefs
    end

    def say(*args)
      @output.say *args
    end

    def ask(label, options={})
      # a quick fix until Thor with STDOUT.noecho things get released
      `stty -echo` if options[:echo] == false

      result = @input.ask label, :cyan, options

      `stty echo` && say("\n") if options[:echo] == false

      result
    end

    def error(msg)
      say msg, :red
    end

    def confirm(msg)
      @input.yes?(msg, :cyan)
    end

    def done
      say "✔︎  Done", :green
    end

    def show_spinner
      @spinner ||= Ninefold::Brutus.new
      @spinner.show
    end

    def hide_spinner
      @spinner.hide
    end

    def with_spinner(&block)
      show_spinner
      yield
      hide_spinner
    end

    def signin
      10.times do
        username = ask("Username:")
        password = ask("Password:", :echo => false)

        with_spinner do
          @user.signin(username, password)
        end

        return done if @user.signed_in?

        error "\nSorry. That username and password was invalid. Please try again"
      end

      error "\nCould not log in"
    end

    def signout
      if confirm("Are you sure?")
        @user.delete
        done
      end
    end
  end

end
