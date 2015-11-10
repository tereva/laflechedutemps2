# == Schema Information
#
# Table name: histories
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'
require 'pp'

describe History do


	let(:user) { FactoryGirl.create(:user) }


	before { @history = user.histories.build(title: "Histoire test", description: "Description histoire test" ) }
	

	subject { @history }

	it { should respond_to(:title) }
	it { should respond_to(:description) }
	it { should respond_to(:user_id) }
	it { should respond_to(:approved) }
	it { should respond_to(:user) }

	its(:user) { should == user }


	describe "accessible attributes" do
	
		it "should not allow access to user_id" do
			expect do
				History.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when user_id is not present" do
		before { @history.user_id = nil }
		it { should_not be_valid }
	end

	

end


