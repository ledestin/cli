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

    def ask(*args)
      # a quick fix until Thor with STDOUT.noecho things get released
      options = args.last.is_a?(Hash) ? args.last : {}
      `stty -echo` if options[:echo] == false

      result = @input.ask *args

      `stty echo` && say("\n") if options[:echo] == false

      result
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
        username = ask("Username:", :cyan)
        password = ask("Password:", :cyan, :echo => false)

        with_spinner do
          @user.signin(username, password)
        end

        return if @user.signed_in?

        say "\nSorry. That username and password was invalid. Please try again", :red
      end

      say "\nCould not log in", :red
    end
  end

end
