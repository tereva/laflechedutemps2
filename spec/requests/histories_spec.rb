require 'spec_helper'

describe "Histories" do

   FactoryGirl.reload
    let(:tev) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }

    let(:approved_history){FactoryGirl.create(:history_simple, user: user, title: "approved", approved: true)}
    
    let(:unapproved_history) { FactoryGirl.create(:history, user: user, description: "An unapproved history")}
    let(:other_user) { FactoryGirl.create(:user) }
    let(:other_history) { FactoryGirl.create(:history, user: other_user, description: "Other unapproved history")}
    let(:other_approved_history) { FactoryGirl.create(:approved_history, user: other_user, description: "Other approved history")}
 

  subject { page }


  describe "index" do

     before do         
      FactoryGirl.create(:history_simple, user: user)
      FactoryGirl.create(:history_simple, user: user, title: "approved", approved: true)
      visit histories_path
    end 

    describe  "for visitor or contib" do

        before {visit histories_path}
        it { should have_content('approved') }
        it { should_not have_content('not approved') }
        it { should have_link('Show') } 
        it { should_not have_link('Edit') } 
        it { should_not have_link('Destroy') }

    end # "for visitor or contib"

    describe  "for admin" do
      
      before do         
        sign_in tev
        visit histories_path
      end
        
      it { should have_link('Edit') } 
      it { should have_link('Destroy') }

    end

  end # index



  describe "edit" do




    
    #before { @histo = History.new(title: "history approved", user_id: 1, approved: true) }

  	describe  "unsigned user" do
      before { visit edit_history_path(approved_history) }
      it { should have_content('Sign in') }
    end # unsigned user


    describe "signed user" do 

      before {sign_in user}

      describe "editing his approved history" do
        before { visit edit_history_path(approved_history) }
        it { should have_content('Edit') }
        it { should_not have_selector('h2', text: 'header') }
        it { should have_selector('h2', text: 'body') }

      end 

      describe "editing his un-approved history" do
        before { visit edit_history_path(unapproved_history) }
        it { should have_content('Edit') }
        it { should have_selector('h2', text: 'header') }
        it { should have_selector('h2', text: 'body') }
      end 
   
      describe "editing someone else un-approved history" do
        before { visit edit_history_path(other_history) }
        it { should have_content('error') }
      end

      describe "editing someone else approved history" do
        before { visit edit_history_path(other_approved_history) }
        it { should have_content('Edit') }
        it { should_not have_selector('h2', text: 'header') }
        it { should have_selector('h2', text: 'body') }
      end

    end # signed user

    describe "signed admin" do 

     
      before {sign_in tev}

      describe "editing any not approved history" do
        before { visit edit_history_path(other_history) }
        it { should have_content('Edit') }
        it { should have_selector('h2', text: 'header') }
        it { should have_selector('h2', text: 'body') }
      end
   
      describe "editing any approved history" do
        before { visit edit_history_path(approved_history) }
        it { should have_content('Edit') }
        it { should have_selector('h2', text: 'header') }
        it { should have_selector('h2', text: 'body') }
      end
    
    end # signed admin

   end #edit

end # Histories
