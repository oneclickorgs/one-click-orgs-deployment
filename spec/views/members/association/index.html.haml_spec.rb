require 'spec_helper'

describe "members/association/index" do

  let(:organisation) {mock_model(Association,
    :members => []
  )}
  let(:members) {[mock_model(Member,
    :last_logged_in_at => Date.new(1993, 1, 1),
    :gravatar_url => nil,
    :name => nil,
    :proposals_count => nil,
    :succeeded_proposals_count => nil,
    :failed_proposals_count => nil,
    :votes_count => nil
  )]}

  before(:each) do
    install_organisation_resolver(organisation)

    allow(view).to receive(:current_organisation).and_return(organisation)
    allow(view).to receive(:current_user)
    allow(view).to receive(:co).and_return(organisation)
    stub_template 'shared/_propose_new_member_form' => "propose_new_member_form"
  end

  context "when the organisation is pending" do
    before(:each) do
      allow(organisation).to receive(:pending?).and_return(true)
      allow(organisation).to receive(:proposed?).and_return(false)

      assign(:pending_members, members)
    end

    it "renders the year of date last logged in" do
      render
      expect(rendered).to have_content('1993')
    end
  end

  context "when the organisation is active" do
    before(:each) do
      allow(organisation).to receive(:pending?).and_return(false)
      allow(organisation).to receive(:proposed?).and_return(false)

      assign(:members, members)
      assign(:pending_members, [])
    end

    it "renders the year of date last logged in" do
      render
      expect(rendered).to have_content('1993')
    end
  end

end
