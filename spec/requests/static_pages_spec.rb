require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do

  let(:pierpoljak){FactoryGirl.create(:user)}
  let(:tev){FactoryGirl.create(:admin)}

  before do 
        FactoryGirl.reload
        10.times { FactoryGirl.create(:approved_history, user: pierpoljak)  }
        FactoryGirl.create(:history, user: pierpoljak)
  end


    describe "with block 5 for all visitor" do
    
    # 5 last approved history

      before {visit root_path}

      it { should_not have_content('history 11')}
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


        # Should list all histories : status : approved / not approved, title, owner, links : show, edit, destroy, approve/un-approve
        # Should list all events  : 
        # Should list all regitres : 

      let(:other_user) { FactoryGirl.create(:user) }
     
      before do
        @histo = FactoryGirl.create(:history, user: pierpoljak, title: "Voyage de Cook")
        @event = FactoryGirl.create(:event, user: other_user, title: "Arrivee a Tahiti")
        @registre = Registre.create(history_id: @histo.id, event_id: @event.id)
        sign_in tev
        visit root_path
      end
   
      it { should have_content('Cook')}
      it { should have_content('Tahiti')}  
      it {should have_link('Show', href: history_path(@histo))}
      it {should have_link('Edit', href: edit_history_path(@histo))}
      it {should have_link('Destroy', href: history_path(@histo))}
      it {should have_link('Destroy', href: history_path(@histo))}



    end # for admin

  end # Home Page

end # Static page


