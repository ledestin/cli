module Ninefold
  class Interaction::Signout < Ninefold::Interaction
    def run
      if confirm("Are you sure?")
        @user.delete
        done
      end
    end
  end
end
