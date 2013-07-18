require 'spec_helper'

describe "admin/coops/show" do

  let(:coop) {mock_model(Coop, :name => "The Locally-Grown Co-operative", :to_param => '111', :members => members)}
  let(:members) {[mock_model(Member, :name => "Bob Smith", :email => nil, :address => nil, :phone => nil)]}

  before(:each) do
    assign(:coop, coop)
  end

  it "renders the name of the coop" do
    render
    rendered.should have_content("The Locally-Grown Co-operative")
  end

  it "renders the members of the coop" do
    render
    rendered.should have_content("Bob Smith")
  end

  it "renders a link to the rules PDF" do
    render
    rendered.should have_selector(:a, :href => '/admin/constitutions/111.pdf')
  end

  it "renders a link to the registration form PDF" do
    render
    rendered.should have_selector(:a, :href => '/admin/registration_forms/111.pdf')
  end

end
