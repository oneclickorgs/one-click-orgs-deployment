require 'rails_helper'

describe 'admin/members/active_organisations' do

  let(:members) {[mock_model(Member, name: 'Bob Smith', organisation_name: 'Widgets Pty')]}

  before(:each) do
    assign(:members, members)
  end

  it "renders the members' names" do
    render
    expect(rendered).to have_content("Bob Smith")
  end

end
