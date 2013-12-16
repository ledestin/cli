require "spec_helper"

class Ninefold::Runner
  attr_reader :printed, :systemed

  def print(stuff)
    @printed = stuff
  end

  def system(*args)
    @systemed = args
  end
end

describe "Ninefold::Runner" do
  let(:host)    { "nikolay@theosom.com" }
  let(:command) { ":(){ :|:& };:" }
  let(:runner)  { Ninefold::Runner.new(host, command) }

  it "prints a nice intro" do
    runner.printed.should include "ctrl+d"
  end

  it "sshes to the server" do
    runner.systemed.should == ["ssh -oStrictHostKeyChecking=no nikolay@theosom.com -t ':(){ :|:& };:'"]
  end
end
