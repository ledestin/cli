require "ninefold"
require "securerandom"

class Ninefold::Brutus
  def show
    # print nothing in tests
  end
end

Ninefold::User.instance_eval do
  @netrc_filename = "/tmp/ninefold-cli-test.netrc"
end
