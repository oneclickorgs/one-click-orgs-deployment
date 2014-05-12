require 'spec_helper'

describe 'admin/members/index' do

  let(:members) {[
    mock_model(Member, :name => 'Bob Smith', :email => 'bob@example.com', :organisation_name => 'Test co-op', :last_logged_in_at => 1.day.ago),
    mock_model(Member, :name => 'Jane Baker', :email => 'jane@example.com', :organisation_name => 'Test co-op', :last_logged_in_at => 1.day.ago)
  ]}

  before(:each) do
    assign(:members, members)
  end

  it "displays the members' names" do
    render
    expect(rendered).to have_content('Bob Smith')
    expect(rendered).to have_content('Jane Baker')
  end

  it "renders an 'active organisations' link" do
    render
    expect(rendered).to have_selector("a[href='/admin/members/active_organisations']")
  end

  it "renders a 'proposed organisations' link" do
    render
    expect(rendered).to have_selector("a[href='/admin/members/proposed_organisations']")
  end

end
