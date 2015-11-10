require 'spec_helper'

describe "StaticPages" do

subject { page }

   describe "Home page" do

	let(:user){ FactoryGirl.create(:user) }

		describe "history block" do
			
			before (:all) { FactoryGirl.create(:history, user:user, approved:false) }
			before (:all) {10.times {FactoryGirl.create(:history, user:user, approved:true) }}
     		before (:each) { visit '/home' }
     		

	        it { should have_content('dernieres Histoires')}
		    it { should_not have_content('Histoire 1')}
	    	it { should have_content('Histoire 2')	}
	    	it { should have_content('Histoire 6')}
			it {  should_not have_content('Histoire 7')}
	 
	   
	   end # History block 

 	end # Home Page

end
