module Ninefold
  class Interaction
    def initialize(output, input, user, prefs)
      @output = output
      @input  = input
      @user   = user
      @prefs  = prefs
    end

    def signin
      10.times do
        email    = @input.ask("Email: ")
        password = @input.ask("Password: ") { |q| q.echo = "*" }

        username, token = @user.signin(email, password)

        if username && token
          @prefs[:username] = username
          @prefs[:token]    = token
          return
        end

        @output.say "Sorry. That email and password was invalid. Please try again", :red
      end

      @output.say "Could not log in", :red
    end
  end
end
