require 'spec_helper'

describe "admin/coops/show" do

  let(:coop) {mock_model(Coop,
    :name => "The Locally-Grown Co-operative",
    :to_param => '111',
    :members => members,
    :directors => [],
    :proposed? => true,
    :active? => false
  )}
  let(:members) {[mock_model(Member, :name => "Bob Smith", :email => nil, :address => nil, :phone => nil, :to_param => '222')]}

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

  it "renders a link to edit each member" do
    render
    rendered.should have_selector(:a, :href => '/admin/members/222/edit')
  end

  it "renders a link to the rules PDF" do
    render
    rendered.should have_selector(:a, :href => '/admin/constitutions/111.pdf')
  end

  it "renders a link to edit the rules" do
    render
    rendered.should have_selector(:a, :href => '/admin/constitutions/111/edit')
  end

  it "renders a link to the registration form PDF" do
    render
    rendered.should have_selector(:a, :href => '/admin/registration_forms/111.pdf')
  end

  it "renders a link to the anti-money laundering form" do
    render
    rendered.should have_selector(:a, :href => '/admin/coops/111/documents/money_laundering')
  end

  it "renders a link to the anti-money laundering form PDF" do
    render
    rendered.should have_selector(:a, :href => '/admin/coops/111/documents/money_laundering.pdf')
  end

  it "renders a link to edit the registration details" do
    render
    rendered.should have_selector(:a, :href => '/admin/registration_forms/111/edit')
  end

  context "when coop is active" do
    before(:each) do
      allow(coop).to receive(:active?).and_return(true)
    end

    it "renders a list of the directors" do
      render
      rendered.should have_selector('.directors')
    end
  end

end
