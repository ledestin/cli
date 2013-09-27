module Ninefold
  class Interaction
    def initialize(output, input, user, prefs)
      @output = output
      @input  = input
      @user   = user
      @prefs  = prefs
    end

    def login
      10.times do
        email    = @input.ask("Email: ")
        password = @input.ask("Password: ") { |q| q.echo = "*" }

        if token = @user.login(email, password)
          @prefs[:token] = token
          return token
        end

        @output.say "Sorry. That email and password was invalid. Please try again", :red
      end

      @output.say "Could not log in", :red

      # make sure to return nil for the token that couldn't be found
      return
    end
  end
end
