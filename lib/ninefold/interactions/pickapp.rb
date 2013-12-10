module Ninefold
  class Interaction::Pickapp < Ninefold::Interaction
    def run
      apps = [1,2,3,4,5].map{ |i| Ninefold::App.new(id: '1', name: "My app ##{i}")}

      app  = pick "Pick app: ", apps

      say "You picked: #{app}"
    end
  end
end
