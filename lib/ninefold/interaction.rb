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
      # a quick fix before Thor with STDOUT.noecho things get released
      options = args.last.is_a?(Hash) ? args.last : {}
      `stty -echo` if options[:echo] == false

      result = @input.ask *args

      `stty echo` && say("\n") if options[:echo] == false

      result
    end

    def show_spinner
      @brutus = Ninefold::Brutus.new
    end

    def hide_spinner
      @brutus.hide
    end

    def with_spinner(&block)
      show_spinner
      yield
      hide_spinner
    end

    def signin
      10.times do
        email    = ask("Email:", :cyan)
        password = ask("Password:", :cyan, :echo => false)
        tokens   = nil

        with_spinner do
          tokens = @user.signin(email, password)
        end

        return tokens if tokens

        say "\nSorry. That email and password was invalid. Please try again\n", :red
      end

      say "\nCould not log in", :red
    end
  end

end
