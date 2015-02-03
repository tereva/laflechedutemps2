require 'spec_helper'

describe "histories/edit" do
  before(:each) do
    @history = assign(:history, stub_model(History,
      :title => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit history form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => histories_path(@history), :method => "post" do
      assert_select "input#history_title", :name => "history[title]"
      assert_select "textarea#history_description", :name => "history[description]"
    end
  end
end
