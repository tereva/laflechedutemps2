require 'spec_helper'

describe "Events" do

   FactoryGirl.reload
    let(:tev) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }

  subject { page }


  describe "index" do

     before do         
      FactoryGirl.create(:event_simple, user: user)
      FactoryGirl.create(:event_simple, user: user, title: "approved", approved: true)
      visit histories_path
    end 

    describe  "for visitor or contib" do

        before {visit events_path}
        it { should have_content('approved') }
        it { should_not have_content('not approved') }
        it { should have_link('Show') } 
        it { should_not have_link('Edit') } 
        it { should_not have_link('Destroy') }

    end # "for visitor or contib"

    describe  "for admin" do
      
      before do         
        sign_in tev
        visit events_path
      end
        
      it { should have_link('Edit') } 
      it { should have_link('Destroy') }

    end

  end # index



end # Events
