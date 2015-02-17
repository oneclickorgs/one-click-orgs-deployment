require 'rails_helper'

describe Proposal do
  
  before(:each) do
    Delayed::Job.delete_all 
        
    default_association_constitution  
    default_association
    default_association_voting_systems
    default_association_member_class
    
    @member = @organisation.members.make!(:member_class => @default_member_class)
    
    @mail = double('mail', :deliver => nil)
    
    allow(ProposalMailer).to receive(:notify_creation).and_return(@mail)
    allow(DecisionMailer).to receive(:notify_new_decision).and_return(@mail)
  end
  
  describe "model associations" do
    describe "comments" do
      it "orders by creation timestamp" do
        comments = [
          Comment.make!(:created_at => 1.day.ago, :body => "C"),
          Comment.make!(:created_at => 5.days.ago, :body => "A"),
          Comment.make!(:created_at => 3.days.ago, :body => "B")
        ]
        proposal = @organisation.proposals.make!
        proposal.comments << comments
        expect(proposal.comments.map(&:body)).to eq(["A", "B", "C"])
      end
    end

    describe 'votes' do
      it 'destroys associated votes when the proposal is destroyed' do
        proposal = @organisation.proposals.make!
        proposal.votes.make!(3)
        expect{proposal.destroy}.to change{Vote.count}.by(-4)
      end
    end

    describe 'voters_for' do
      it 'returns members who cast "for" votes' do
        proposal = @organisation.proposals.make!
        proposal.votes.make!(2)
        expect(proposal.voters_for).to eq(proposal.votes.map(&:member))
      end
    end
  end
  
  it "should close early proposals" do
    member_0, member_1, member_2 = @organisation.members.make!(3, :member_class => @default_member_class)
    member_3, member_4 = @organisation.members.make!(2, :created_at => Time.now + 1.day, :member_class => @default_member_class)
    
    proposal = @organisation.proposals.create!(:proposer_member_id => member_1.id, :title => 'test', :parameters => nil) 
    [member_0, member_2].each { |m| m.cast_vote(:for, proposal)}
    
    expect {
      expect(@organisation.proposals.close_early_proposals).to include(proposal)
    }.to change(Decision, :count).by(1)
    
    expect(proposal.decision).not_to be_nil
  end
  
  it "should close due proposals" do    
    proposal = @organisation.proposals.make!(:proposer_member_id => @member.id, :close_date=>Time.now - 1.day, :parameters => nil)  
    expect(@organisation.proposals.close_due_proposals).to include(proposal)
    
    proposal.reload
    expect(proposal).to be_closed
  end
  
  it "should send out an email to each member after a Proposal has been made" do
    expect(@organisation.members.count).to be > 0
    @member.member_class.set_permission!(:vote, true)
    
    expect(ProposalMailer).to receive(:notify_creation).and_return(double('email', :deliver => nil))
    @organisation.proposals.make!(:proposer => @member)
  end
  
  describe "closing" do
    before(:each) do
      expect(@organisation.members.count).to be > 0

      @p = @organisation.proposals.make!(:proposer => @member)
      allow(@p).to receive(:passed?).and_return(true)
      # @p.stub(:create_decision).and_return(@decision = mock_model(Decision, :send_email => nil))
    end
    
    context "when proposal is a Founding Proposal" do
      before(:each) do
        allow(@organisation).to receive(:can_hold_founding_vote?).and_return(true)
        @p = FoundAssociationProposal.make!(:proposer => @member, :organisation => @organisation)
        allow(@p).to receive(:passed?).and_return(true)
        allow(@p).to receive(:create_decision).and_return(@decision = mock_model(Decision, :send_email => nil))
        
        association_is_proposed
      end
      
      it "creates a decision" do
        expect(@p).to receive(:create_decision)
        @p.close!
      end
    end
  end
  
  describe "to_event" do
    it "should list open proposals as 'proposal's" do
      expect(@organisation.proposals.make!(:state => 'open').to_event[:kind]).to eq(:proposal)
    end
    
    it "should list closed, accepted proposals as 'proposal's" do
      expect(@organisation.proposals.make!(:state => 'accepted').to_event[:kind]).to eq(:proposal)
    end
    
    it "should list closed, rejected proposals as 'failed proposal's" do
      proposal = @organisation.proposals.make!(:state => 'rejected')
      expect(proposal.open?).to be false
      
      expect(proposal.to_event[:kind]).to eq(:failed_proposal)
    end
  end
  
  describe "vote counting" do
    before(:each) do
      @proposal = @organisation.proposals.create
      3.times{Vote.create(:proposal => @proposal, :for => true)}
      4.times{Vote.create(:proposal => @proposal, :for => false)}
    end
    
    it "should count the for votes" do
      expect(@proposal.votes_for).to eq(3)
    end
    
    it "should count the against votes" do
      expect(@proposal.votes_against).to eq(4)
    end
  end
  
  describe "#member_count" do
    before(:each) do
      @default_member_class.set_permission!(:vote, true)
    end
    
    it "includes active, inducted members who joined before the proposal was created" do
      expect(@organisation.members.count).to eq(1)
      
      member_2, member_3, member_4 = @organisation.members.make!(3, :member_class => @default_member_class)
      
      @proposal = @organisation.proposals.make!(:proposer_member_id => @member.id, :title => 'test', :parameters => nil)
      
      expect(@organisation.members.count).to eq(4)
      expect(@proposal.member_count).to eq(4)
      
      # Test that newer members aren't included
      member_5 = @organisation.members.make!(:member_class => @default_member_class, :created_at => Time.now.utc, :inducted_at => Time.now.utc)
      expect(@organisation.members.count).to eq(5)
      expect(@proposal.member_count).to eq(4)
      
      # Test that uninducted members aren't included
      member_2.inducted_at = nil
      member_2.state = 'pending'
      member_2.save!
      expect(@organisation.members.count).to eq(5)
      expect(@proposal.member_count).to eq(3)
    end
    
    it "includes members who were founding members, but who haven't yet been inducted" do
      # Don't want to deal with FoundAssociationProposal validation errors
      allow(ProposalMailer).to receive(:notify_foundation_proposal).and_return(double('email', :deliver => nil))
      
      member_2, member_3 = @organisation.members.make!(2, :member_class => @default_member_class, :inducted_at => nil)
      
      fap = @organisation.found_association_proposals.make(:proposer_member_id => @member.id)
      # More validation workarounds
      allow(fap).to receive(:association_must_be_ready).and_return(true)
      fap.save!
      
      proposal = @organisation.proposals.make!(:proposer_member_id => @member.id)
      expect(proposal.member_count).to eq(3)
    end
  end
  
  describe "creating" do
    before(:each) do
      @proposer = mock_model(Member)
      @organisation = mock_model(Organisation,
        :pending? => false,
        :constitution => double("constitution", :voting_period => 3600)
      )

      @proposal = Proposal.new(
        :title => "Buy more tables"
      )
      @proposal.organisation = @organisation
      @proposal.proposer = @proposer
      
      # Stub out ProposalMailerObserver
      @organisation.stub_chain(:members, :active).and_return([])
    end
    
    it "creates a support vote by the proposer" do
      expect(@proposer).to receive(:cast_vote).with(:for, anything)
      @proposal.save
    end
  end
  
  describe "starting" do
    it "sets the close date" do
      @proposal = @organisation.proposals.make!(:draft)
      expect(@proposal.close_date).to be_blank

      @proposal.start!
      
      @proposal.reload
      expect(@proposal.close_date).to be_present
    end
  end
  
  describe "decision notification message" do
    it "returns nil" do
      expect(Proposal.new.decision_notification_message).to be_nil
    end
  end
  
  describe "amending voting period" do
    before(:each) do
      @proposer = mock_model(Member, :cast_vote => nil)
      @constitution = double("constitution")
      @organisation = mock_model(Organisation,
        :pending? => false,
        :constitution => @constitution
      )
      @organisation.stub_chain(:members, :active).and_return([])
      
      @proposal = Proposal.new(:title => 'Buy more tables')
      @proposal.organisation = @organisation
      @proposal.proposer = @proposer
    end
    
    it "adjusts the close date accordingly" do
      allow(@constitution).to receive(:voting_period).and_return(3600)
      @proposal.voting_period_in_days = 2
      @proposal.save
      expect(@proposal.close_date).to be > 1.day.from_now
    end
    
    it "handles being given a string" do
      allow(@constitution).to receive(:voting_period).and_return(3600)
      @proposal.voting_period_in_days = "2"
      @proposal.save
      expect(@proposal.close_date).to be > 1.day.from_now
    end
  end
end
