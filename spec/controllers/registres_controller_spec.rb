require 'spec_helper'

describe RegistresController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:admin){FactoryGirl.create(:admin)}

  let(:histo) {FactoryGirl.create(:history, user: user, description: "An history")}
  let(:evt) {FactoryGirl.create(:event, user: other_user)}
  let(:registre) { Registre.create(history_id: histo.id, event_id: evt.id)}

  before { sign_in admin }

  describe "validating a register with Ajax" do

   it "should approved the registre" do
    expect do
      xhr :post, :toggle_approve, id: registre.id
    end.to change{registre.approved?}.from(false).to(true)
  end

  it "should approved the history" do
    expect do
      xhr :post, :toggle_approve, id: registre.id
    end.to change{histo.approved?}.from(false).to(true)
  end




  end # "creating a relationship with Ajax"

end # RelationshipsController

