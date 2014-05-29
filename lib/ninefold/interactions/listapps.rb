module Ninefold
  class Interaction::Listapps < Ninefold::Interaction
    def run(apps)
      list apps, empty_message: "Apparently you don't have any active app on this account"
    end
  end
end
