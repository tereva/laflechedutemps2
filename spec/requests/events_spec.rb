require 'spec_helper'

describe "Events" do

    #FactoryGirl.reload
    let(:tev) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }
    let(:not_approved_event) {FactoryGirl.create(:event_simple, user: user)}
    let(:approved_event) {FactoryGirl.create(:event_simple, user: user, title: "approved", approved: true)}

  subject { page }


  describe "index" do

     before do         
      FactoryGirl.create(:event_simple, user: user)
      FactoryGirl.create(:event_simple, user: user, title: "approved", approved: true)
      visit events_path
    end 

    it { should have_content('approved') }
    it { should_not have_content('not approved') }
    it { should have_link('Show') }  
    it { should_not have_link('New Event') } 
    it { should_not have_link('Edit') } 
    it { should_not have_link('Destroy') }

  end # index


  describe "show" do

    describe "approved event" do
      before {visit event_path(approved_event)}
      it { should have_content('approved') }
      it { should_not have_content('not approved') } 
      it { should_not have_link('New Event') } 
      it { should_not have_link('Edit') } 
      it { should_not have_link('Destroy') }
    end

    describe "not approved event" do
      before {visit event_path(not_approved_event)}
      it { should have_content('Action impossible') }
      it { should_not have_content('not approved') }
    end

    describe "not approved event for admin" do
      before do 
        sign_in tev
        visit event_path(not_approved_event)
      end
      it { should have_content('not approved') }
    end 

  end # show


end # Events
