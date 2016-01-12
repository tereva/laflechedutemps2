require 'spec_helper'

describe Gedcom do

	let(:user) { FactoryGirl.create(:user) }
	before do
		# This code is wrong!
		@gedcom = Gedcom.new(name: "gedcom_name", content: "Lorem ipsum", user_id: user.id)
	end
	subject { @gedcom}
	it { should respond_to(:name) }
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }

end
