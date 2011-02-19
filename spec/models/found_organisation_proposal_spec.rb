require 'spec_helper'

describe FoundOrganisationProposal do
  it "uses the Founding voting system" do
    FoundOrganisationProposal.new.voting_system.should == VotingSystems::Founding
  end
  
  describe "validation" do
    before(:each) do
      @proposal = FoundOrganisationProposal.new(:proposer => mock_model(Member), :title => "Title")
      @proposal.organisation = @organisation = mock_model(Organisation, :members => [])
      @organisation.stub!(:can_hold_founding_vote?).and_return(false)
    end
    
    it "fails on create if the organisation is not ready for a founding vote" do
      @organisation.should_receive(:can_hold_founding_vote?).and_return(false)
      @proposal.save.should be_false
    end
    
    it "succeeds on create if the organisation is ready for a founding vote" do
      @organisation.should_receive(:can_hold_founding_vote?).and_return(true)
      @proposal.save.should be_true
    end
    
    it "succeeds on update regardless of readiness of organisation" do
      @organisation.stub!(:can_hold_founding_vote?).and_return(true)
      @proposal.save!
      
      @organisation.stub!(:can_hold_founding_vote?).and_return(false)
      @proposal.save.should be_true
    end
  end
  
  describe "enactment" do
    before(:each) do
      # Set up mock organisation and member classes
      @organisation = mock_model(Organisation, :active! => nil, :save => false)
      
      @founder_class = mock_model(MemberClass, :name => 'Founder', :description => nil)
      @founding_member_class = mock_model(MemberClass, :name => 'Founding Member', :description => nil)
      @member_class = mock_model(MemberClass, :name => 'Member', :description => nil)
      
      @organisation.stub!(:member_classes).and_return(@member_classes_association = mock('member classes association'))
      @member_classes_association.stub!(:find_by_name).with('Founder').and_return(@founder_class)
      @member_classes_association.stub!(:find_by_name).with('Founding Member').and_return(@founding_member_class)
      @member_classes_association.stub!(:find_by_name).with('Member').and_return(@member_class)
      
      # Mock up a founder and three founding members
      @members = [
        mock_model(Member, :member_class => @founder_class,         :member_class= => nil, :save! => true),
        mock_model(Member, :member_class => @founding_member_class, :member_class= => nil, :save! => true),
        mock_model(Member, :member_class => @founding_member_class, :member_class= => nil, :save! => true),
        mock_model(Member, :member_class => @founding_member_class, :member_class= => nil, :save! => true, :eject! => true)
      ]
      @organisation.stub!(:members).and_return(@members)
      
      # Mock that founder and first two founding members vote for the founding,
      # and that the final founding member votes against
      @votes = [
        mock_model(Vote, :member_id => @members[0].id, :for? => true),
        mock_model(Vote, :member_id => @members[1].id, :for? => true),
        mock_model(Vote, :member_id => @members[2].id, :for? => true),
        mock_model(Vote, :member_id => @members[3].id, :for? => false)
      ]
      
      @proposal = FoundOrganisationProposal.new(:proposer => @members[0], :organisation => @organisation)
      @proposal.stub!(:votes).and_return(@votes)
    end
    
    it "sets the member class of all existing members to 'Member'" do
      @members.each do |member|
        member.should_receive(:member_class=).with(@member_class).ordered
        member.should_receive(:save!).ordered
      end
      
      @proposal.enact!
    end
  end
end
