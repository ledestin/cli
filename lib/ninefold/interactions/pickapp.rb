module Ninefold
  class Interaction::Pickapp < Ninefold::Interaction
    def run(apps)
      pick "Please pick the app:", apps
    end
  end
end
