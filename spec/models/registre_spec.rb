# == Schema Information
#
# Table name: registres
#
#  id         :integer         not null, primary key
#  history_id :integer
#  event_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'


describe Registre do

	# pas de registre sans Histoire & Event
	# registre repond a : event_id, history_id, approved
	# par defaut registre.approved FALSE


	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }
	let(:histo) {FactoryGirl.create(:history, user: user, description: "An history")}
	let(:evt) {FactoryGirl.create(:event, user: other_user)}

	let(:registre) { Registre.new(history_id: histo.id, event_id: evt.id)}
	#let(:registre) { histo.registres.build(id: 0, event_id: evt.id)}
	
	#before { puts registre.id}

	subject { registre }

	it { should respond_to(:approved) }
	it { should respond_to(:event_id) }
	it { should respond_to(:history_id) }

	it { should be_valid }

	# approved is false by default
	it { should_not be_approved }

	describe "accessible attributes" do
	
		it "should not allow access to approved" do
			expect do
				Registre.new(approved: true)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end	

	describe "when history_id is not present" do
		before { registre.history_id = nil }
		it { should_not be_valid }
	end
	
	describe "when event_id is not present" do
		before { registre.event_id = nil }
		it { should_not be_valid }
	end


	  describe "when registre is approved" do
	   before { registre.toggle!(:approved) }
	   it { should be_approved }

	   	it "should validate history" do
    		registre.history.should  be_approved
   		end

   		it "should validate event" do
    		registre.event.should  be_approved
   		end

	  end

  	describe "when registre already exist" do

		before do
			same_registre = registre.dup
			same_registre.save
		end

		it { should_not be_valid }

	  end


end
