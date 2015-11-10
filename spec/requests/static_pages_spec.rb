require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do

  let(:user){FactoryGirl.create(:user)}
  let(:admin){FactoryGirl.create(:admin)}

    describe "with block 5 for all visitor" do
    

      before do 
        FactoryGirl.reload
        10.times { FactoryGirl.create(:approved_history, user: user)  }
        FactoryGirl.create(:history, user: user, description: "An un-approved history 11")
        visit root_path 
      end

      it { should_not have_content('un-approved history 11')}
      it { should have_content('history 10')}
      it { should have_content('history 9')} 
      it { should have_content('history 8')}
      it { should have_content('history 7')} 
      it { should have_content('history 6')}
      it { should_not have_content('history 5')}
      it {should_not have_link('Edit', href: edit_history_path(8))}
      it {should have_link('Show', href: history_path(8))}

      it { should_not have_link('Edit') }
      it { should_not have_link('Destroy') }
    
    end # block 5

    describe "for admin user" do

      let(:other_user) { FactoryGirl.create(:user) }
     
      before do
        @histo = FactoryGirl.create(:history, user: user, title: "Voyage de Cook")
        @event = FactoryGirl.create(:event, user: other_user, title: "Arrivee a Tahiti")
        @registre = Registre.create(history_id: @histo.id, event_id: @event.id)
        sign_in admin
        visit root_path
      end
   
      it { should have_content('Cook')}
      it { should have_content('Tahiti')}



    end # for admin

  end # Home Page

end # Static page


