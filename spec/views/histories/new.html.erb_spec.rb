require 'spec_helper'

describe "histories/new" do
  before(:each) do
    assign(:history, stub_model(History,
      :title => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new history form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => histories_path, :method => "post" do
      assert_select "input#history_title", :name => "history[title]"
      assert_select "textarea#history_description", :name => "history[description]"
    end
  end
end
