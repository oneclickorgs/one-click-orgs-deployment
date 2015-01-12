require 'rails_helper'

describe ChangeVotingSystemProposal do
  before do
    default_association
    @constitution_voting_system = @organisation.clauses.set_text!('constitution_voting_system', 'RelativeMajority')        
    @proposed_system = 'Unanimous'
  end
  
  it "should change voting system after successful proposal" do
    @p = @organisation.change_voting_system_proposals.new

    expect(Clause).to receive(:set_text!).with('constitution_voting_system', 'Unanimous')
    passed_proposal(@p, 'proposal_type'=>'constitution', 'proposed_system'=>@proposed_system).call
  end
  
  it "has a decision notification message" do
    expect(ChangeVotingSystemProposal.new.decision_notification_message).to be_present
  end
  
end
