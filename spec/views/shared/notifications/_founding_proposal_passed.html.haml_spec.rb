require 'spec_helper'

describe 'shared/notifications/_founding_proposal_passed' do
  it "should not list ejected members" do
    @ejected_member = mock_model(Member, :name => "Edward Ejected")
    @organisation = mock_model(Organisation, :name => "Test Organisation", :created_at => 1.hour.ago)
    @organisation.stub(:members).and_return(@members_association = [@ejected_member])
    @members_association.stub(:active).and_return([])
    @members_association.stub(:pending).and_return([])
    view.stub(:co).and_return(@organisation)
    render
    rendered.should_not contain(@ejected_member.name)
  end
end
