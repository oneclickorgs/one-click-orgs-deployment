require 'spec_helper'

describe ResolutionProposalsController do
  
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end
  
  describe "GET new" do
    before(:each) do
      @resolution_proposals_association = mock("resolution proposals association")
      @organisation.stub(:resolution_proposals).and_return(@resolution_proposals_association)
      
      @resolution_proposal = mock_model(ResolutionProposal)
      @resolution_proposals_association.stub(:build).and_return(@resolution_proposal)
    end
    
    it "builds a new resolution proposal" do
      @resolution_proposals_association.should_receive(:build).and_return(@resolution_proposal)
      get :new
    end
    
    it "assigns the new resolution proposal" do
      get :new
      assigns[:resolution_proposal].should == @resolution_proposal
    end
    
    it "succeeds" do
      get :new
      response.should be_successful
    end
  end
  
  describe "POST create" do
    before(:each) do
      @resolution_proposal_params = {'description' => 'Buy more sporks.'}
      @resolution_proposals_association = mock("resolution proposals association")
      @resolution_proposal = mock_model(ResolutionProposal)
      @organisation.stub(:resolution_proposals).and_return(@resolution_proposals_association)
      @resolution_proposals_association.stub(:build).and_return(@resolution_proposal)
      @resolution_proposal.stub(:proposer=)
      @resolution_proposal.stub(:save!)
    end
    
    def post_create
      post :create, 'resolution_proposal' => @resolution_proposal_params
    end
    
    it "builds the new resolution proposal" do
      @resolution_proposals_association.should_receive(:build).with(@resolution_proposal_params).and_return(@resolution_proposal)
      post_create
    end
    
    it "assigns the current user as the proposer" do
      @resolution_proposal.should_receive(:proposer=).with(@user)
      post_create
    end
    
    it "saves the new resolution proposal" do
      @resolution_proposal.should_receive(:save!)
      post_create
    end
    
    it "redirects to the proposals page" do
      post_create
      response.should redirect_to('/proposals')
    end
    
    context "when the new resolution proposal cannot be saved" do
      it "handles the error"
    end
    
  end
  
end
