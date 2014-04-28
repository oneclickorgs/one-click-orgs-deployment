require 'spec_helper'

describe 'shared/notifications/_founding_proposal_passed' do

  let(:organisation) {mock_model(Organisation,
    name: "Test Organisation",
    created_at: Time.utc(2014, 2, 28),
    members: members_association,
    found_association_proposals: found_association_proposals_association
  )}
  let(:members_association) {[@ejected_member]}
  let(:ejected_member) {mock_model(Member, name: 'Edward Ejected')}
  let(:found_association_proposals_association) {double(
    last: found_association_proposal
  )}
  let(:found_association_proposal) {mock_model(FoundAssociationProposal,
    close_date: Time.utc(2014, 3, 3)
  )}

  before(:each) do
    allow(members_association).to receive(:active).and_return([])
    allow(members_association).to receive(:pending).and_return([])
    allow(view).to receive(:co).and_return(organisation)
  end

  it "should not list ejected members" do
    render
    rendered.should_not contain(ejected_member.name)
  end

  it "renders the date the founding vote closed" do
    render
    expect(rendered).to have_content("3 March 2014")
  end
end
