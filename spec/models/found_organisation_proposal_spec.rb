require 'spec_helper'

describe FoundOrganisationProposal do
  it "uses the Founding voting system" do
    FoundOrganisationProposal.new.voting_system.should == VotingSystems::Founding
  end
end
