require 'spec_helper'

describe "constitution proposal bundles" do
  
  def mock_proposal
    double('proposal',
      :save! => true,
      :valid? => true,
      :proposer= => nil
    )
  end
  
  before(:each) do 
    default_association
    default_association_constitution
    
    @user = association_login
  end
  
  describe "POST create" do
    before(:each) do
      set_permission!(@user, :constitution_proposal, true)
      @proposal = mock_proposal
      
      allow(ChangeTextProposal).to receive(:new).and_return(mock_proposal)
      allow(ChangeVotingSystemProposal).to receive(:new).and_return(mock_proposal)
      allow(ChangeBooleanProposal).to receive(:new).and_return(mock_proposal)
      allow(ChangeVotingPeriodProposal).to receive(:new).and_return(mock_proposal)
    end
    
    def post_create
      post '/constitution_proposal_bundles',
        "constitution_proposal_bundle" => {
          "objectives" => "New objectives",
          "constitution_voting_system" => "Unanimous",
          "assets" => "1",
          "voting_period" => "1209600",
          "organisation_name" => "New name",
          "general_voting_system" => "AbsoluteMajority",
          "membership_voting_system" => "AbsoluteTwoThirdsMajority"
        }
    end
    
    it "should create a proposal to change the organisation name" do
      expect(ChangeTextProposal).to receive(:new).with({
        :name => 'organisation_name',
        :value => 'New name'
      },{}).once.ordered.and_return(@proposal)
      expect(@proposal).to receive(:proposer=).with(@user)
      expect(@proposal).to receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the objectives" do
      expect(ChangeTextProposal).to receive(:new).with({
          :name => 'organisation_objectives',
          :value => 'New objectives'
      },{}).and_return(@proposal)
      expect(@proposal).to receive(:proposer=).with(@user)
      expect(@proposal).to receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the general voting system" do
      expect(ChangeVotingSystemProposal).to receive(:new).with({
        :proposal_type => 'general',
        :proposed_system => 'AbsoluteMajority'
      },{}).and_return(@proposal)
      expect(@proposal).to receive(:proposer=).with(@user)
      expect(@proposal).to receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the membership voting system" do
      expect(ChangeVotingSystemProposal).to receive(:new).with({
        :proposal_type => 'membership',
        :proposed_system => 'AbsoluteTwoThirdsMajority'
      },{}).and_return(@proposal)
      expect(@proposal).to receive(:proposer=).with(@user)
      expect(@proposal).to receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the constitution voting system" do
      expect(ChangeVotingSystemProposal).to receive(:new).with({
        :proposal_type => 'constitution',
        :proposed_system => 'Unanimous'
      },{}).and_return(@proposal)
      expect(@proposal).to receive(:proposer=).with(@user)
      expect(@proposal).to receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to allow assets" do
      expect(ChangeBooleanProposal).to receive(:new).with({
        :name => 'assets',
        :value => true,
        :title => "Change the constitution to allow holding, transferral and disposal of material assets and intangible assets"
      },{}).and_return(@proposal)
      expect(@proposal).to receive(:proposer=).with(@user)
      expect(@proposal).to receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the voting period" do
      expect(ChangeVotingPeriodProposal).to receive(:new).with({
        :new_voting_period => "1209600"
      },{}).and_return(@proposal)
      expect(@proposal).to receive(:proposer=).with(@user)
      expect(@proposal).to receive(:save!).and_return(true)
      
      post_create
    end
    
    context "when user only changes some of the settings" do
      def post_create
        # Only change objectives and general_voting_system
        post '/constitution_proposal_bundles',
          "constitution_proposal_bundle" => {
            "objectives" => "New objectives",
            "constitution_voting_system" => "AbsoluteTwoThirdsMajority",
            "assets" => "0",
            "voting_period" => "259200",
            "organisation_name" => @organisation.name,
            "general_voting_system" => "AbsoluteMajority",
            "membership_voting_system" => "Veto"
          }
      end
      
      it "should create a proposal to change the objectives" do
        expect(ChangeTextProposal).to receive(:new).with({
            :name => 'organisation_objectives',
            :value => 'New objectives'
        },{}).and_return(@proposal)
        expect(@proposal).to receive(:proposer=).with(@user)
        expect(@proposal).to receive(:save!).and_return(true)

        post_create
      end
      
      it "should create a proposal to change the general voting system" do
        expect(ChangeVotingSystemProposal).to receive(:new).with({
          :proposal_type => 'general',
          :proposed_system => 'AbsoluteMajority'
        },{}).and_return(@proposal)
        expect(@proposal).to receive(:proposer=).with(@user)
        expect(@proposal).to receive(:save!).and_return(true)

        post_create
      end
      
      it "should not create a proposal to change the organisation name" do
        expect(ChangeTextProposal).not_to receive(:new).with(hash_including(
          :name => 'organisation_name'
        ))

        post_create
      end
      
      it "should not create a proposal to change the membership voting system" do
        expect(ChangeVotingSystemProposal).not_to receive(:new).with(hash_including(
          :proposal_type => 'membership',
          :proposed_system => 'AbsoluteTwoThirdsMajority'
        ))
        
        post_create
      end

      it "should create a proposal to change the constitution voting system" do
        expect(ChangeVotingSystemProposal).not_to receive(:new).with(hash_including(
          :proposal_type => 'constitution',
          :proposed_system => 'Unanimous'
        ))

        post_create
      end

      it "should create a proposal to allow assets" do
        expect(ChangeBooleanProposal).not_to receive(:new).with(hash_including(
          :name => 'assets'
        ))

        post_create
      end

      it "should not create a proposal to change the voting period" do
        expect(ChangeVotingPeriodProposal).not_to receive(:new)

        post_create
      end
    end
    
    context "when user does not have permission to create constitutional proposals" do
      before(:each) do
        set_permission!(@user, :constitution_proposal, false)
      end
      
      it "redirects" do
        post_create
        expect(response).to be_redirect
      end
      
      it "sets an error flash" do
        post_create
        expect(flash[:error]).to be_present
      end
      
      it "does not create any proposals" do
        expect(ChangeTextProposal).not_to receive(:new)
        expect(ChangeBooleanProposal).not_to receive(:new)
        expect(ChangeVotingPeriodProposal).not_to receive(:new)
        expect(ChangeVotingSystemProposal).not_to receive(:new)
        post_create
      end
    end
  end
  
end
