
require 'spec_helper'

describe Event do


	let(:user) { FactoryGirl.create(:user) }


	before { @event = user.events.build(title: "Event", start: "2014-09-15 02:09:05.412232", place: "paris" ) }
	
	subject { @event }

	it { should respond_to(:title) }
	it { should respond_to(:start) }
	it { should respond_to(:user_id) }
	it { should respond_to(:approved) }
	it { should respond_to(:user) } 

	its(:user) { should == user }


	it { should be_valid }


	describe "accessible attributes" do
	
		it "should not allow access to user_id" do
			expect do
				Event.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when user_id is not present" do
		before { @event.user_id = nil }
		it { should_not be_valid }
	end

	

end


