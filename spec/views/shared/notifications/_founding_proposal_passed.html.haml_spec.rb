require 'spec_helper'

describe 'shared/notifications/_founding_proposal_passed' do

  let(:found_association_proposal) {mock_model(FoundAssociationProposal, close_date: Time.utc(2014, 3, 3))}
  let(:organisation) {mock_model(Organisation,
    name: "Test Organisation",
    created_at: Time.utc(2014, 2, 28),
    members: members_association,
    found_association_proposals: found_association_proposals_association
  )}
  let(:members_association) {double(active: [], pending: [])}
  let(:found_association_proposals_association) {double(last: found_association_proposal)}

  it "should not list ejected members" do
    @ejected_member = mock_model(Member, :name => "Edward Ejected")
    @organisation = mock_model(Organisation,
      :name => "Test Organisation",
      :created_at => 1.hour.ago,
      :found_association_proposals => found_association_proposals_association
    )
    @organisation.stub(:members).and_return(@members_association = [@ejected_member])
    @members_association.stub(:active).and_return([])
    @members_association.stub(:pending).and_return([])
    view.stub(:co).and_return(@organisation)
    render
    rendered.should_not contain(@ejected_member.name)
  end

  it "renders the date the founding vote closed" do
    allow(found_association_proposal).to receive(:close_date).and_return(Time.utc(2014, 3, 3))
    allow(view).to receive(:co).and_return(organisation)
    render
    expect(rendered).to have_content("3 March 2014")
  end
end
