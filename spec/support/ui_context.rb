shared_context "ui tests" do

  let(:output) { Ninefold::Spec::Output.new }
  let(:input)  { Ninefold::Spec::Input.new  }
  let(:user)   { Ninefold::Spec::User.new   }
  let(:prefs)  { {} }
  let(:ui_class) { nil }
  let(:ui) { ui_class.new(output, input, user, prefs) }

  subject(:interaction) { ui.run }

end
