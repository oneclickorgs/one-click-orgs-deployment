require 'rails_helper'

describe FoundAssociationProposal do
  it "uses the Founding voting system" do
    expect(FoundAssociationProposal.new.voting_system).to eq(VotingSystems::Founding)
  end

  describe "validation" do
    before(:each) do
      @proposal = FoundAssociationProposal.new(:title => "Title")
      @proposal.proposer = mock_model(Member)
      @proposal.organisation = @organisation = mock_model(Association, :members => (@members_association = []), :name => "Test association")
      allow(@organisation).to receive(:can_hold_founding_vote?).and_return(false)
      allow(@members_association).to receive(:active).and_return([])
    end

    it "fails on create if the association is not ready for a founding vote" do
      expect(@organisation).to receive(:can_hold_founding_vote?).and_return(false)
      expect(@proposal.save).to be false
    end

    it "succeeds on create if the association is ready for a founding vote" do
      expect(@organisation).to receive(:can_hold_founding_vote?).and_return(true)
      expect(@proposal.save).to be true
    end

    it "succeeds on update regardless of readiness of association" do
      allow(@organisation).to receive(:can_hold_founding_vote?).and_return(true)
      @proposal.save!

      allow(@organisation).to receive(:can_hold_founding_vote?).and_return(false)
      expect(@proposal.save).to be true
    end
  end

  describe "enactment" do
    before(:each) do
      # Set up mock association and member classes
      @organisation = mock_model(Association, :found! => nil, :save => false)

      @founder_class = mock_model(MemberClass, :name => 'Founder', :description => nil)
      @founding_member_class = mock_model(MemberClass, :name => 'Founding Member', :description => nil)
      @member_class = mock_model(MemberClass, :name => 'Member', :description => nil)

      allow(@organisation).to receive(:member_classes).and_return(@member_classes_association = double('member classes association'))
      allow(@member_classes_association).to receive(:find_by_name).with('Founder').and_return(@founder_class)
      allow(@member_classes_association).to receive(:find_by_name).with('Founding Member').and_return(@founding_member_class)
      allow(@member_classes_association).to receive(:find_by_name).with('Member').and_return(@member_class)

      # Mock up a founder and four founding members
      @members = [
        mock_model(Member, :member_class => @founder_class,         :member_class= => nil, :induct! => true, :save! => true),
        mock_model(Member, :member_class => @founding_member_class, :member_class= => nil, :induct! => true, :save! => true),
        mock_model(Member, :member_class => @founding_member_class, :member_class= => nil, :induct! => true, :save! => true),
        mock_model(Member, :member_class => @founding_member_class, :member_class= => nil, :induct! => true, :save! => true, :eject! => true),
        mock_model(Member, :member_class => @founding_member_class, :member_class= => nil, :induct! => true, :save! => true, :eject! => true)
      ]
      allow(@organisation).to receive(:members).and_return(@members)

      # Mock that founder and first two founding members vote for the founding,
      # the third founding member votes against, and the final founding member
      # abstains.
      @votes = [
        mock_model(Vote, :member_id => @members[0].id, :for? => true),
        mock_model(Vote, :member_id => @members[1].id, :for? => true),
        mock_model(Vote, :member_id => @members[2].id, :for? => true),
        mock_model(Vote, :member_id => @members[3].id, :for? => false)
      ]

      @proposal = FoundAssociationProposal.new
      @proposal.organisation = @organisation
      @proposal.proposer = @members[0]
      allow(@proposal).to receive(:votes).and_return(@votes)
    end

    it "sets the member class of all existing members to 'Member'" do
      @members.each do |member|
        expect(member).to receive(:member_class=).with(@member_class).ordered
        expect(member).to receive(:save!).ordered
      end

      @proposal.enact!
    end

    it "founds the association" do
      expect(@organisation).to receive(:found!)
      @proposal.enact!
    end

    it "ejects members who abstained" do
      expect(@members[4]).to receive(:eject!)
      @proposal.enact!
    end

    it "inducts the members who voted in favour" do
      [@members[0], @members[1], @members[2]].each do |member|
        expect(member).to receive(:induct!)
      end

      @proposal.enact!
    end

    it "does not induct the members who voted against, or who abstained" do
      [@members[3], @members[4]].each do |member|
        expect(member).not_to receive(:induct!)
      end

      @proposal.enact!
    end
  end

  describe "starting" do
    before(:each) do
      @proposer = mock_model(Member)
      @organisation = mock_model(Association,
        :pending? => true,
        :can_hold_founding_vote? => true,
        :name => "Test association"
      )

      @proposal = FoundAssociationProposal.new(
        :title => "Proposal to form association"
      )
      @proposal.organisation = @organisation
      @proposal.proposer = @proposer

      # Stub out ProposalMailerObserver
      allow(@organisation).to receive(:members).and_return([])
    end

    it "does not create a support vote by the proposer" do
      expect(@proposer).not_to receive(:cast_vote).with(:for, anything)
      @proposal.save
    end
  end
end
