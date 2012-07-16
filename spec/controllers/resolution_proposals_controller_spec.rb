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

  describe "GET edit" do
    before(:each) do
      @resolution_proposals_association = mock("resolution proposals association")
      @organisation.stub(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      @resolution_proposals_association.stub(:find).and_return(@resolution_proposal)
    end

    def get_edit
      get :edit, :id => '1'
    end

    it "finds the resolution proposal" do
      @resolution_proposals_association.should_receive(:find).with('1').and_return(@resolution_proposal)
      get_edit
    end

    it "assigns the resolution proposal" do
      get_edit
      assigns[:resolution_proposal].should == @resolution_proposal
    end

    it "is successful" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      @resolution_proposal_params = {'description' => 'New description.'}
      
      @resolution_proposals_association = mock("resolution proposals association")
      @organisation.stub(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      @resolution_proposals_association.stub(:find).and_return(@resolution_proposal)

      @resolution_proposal.stub(:update_attributes)
    end

    def put_update
      put :update, 'id' => '1', 'resolution_proposal' => @resolution_proposal_params
    end

    it "finds the resolution proposal" do
      @resolution_proposals_association.should_receive(:find).with('1').and_return(@resolution_proposal)
      put_update
    end

    it "updates the resolution proposal's attributes" do
      @resolution_proposal.should_receive(:update_attributes).with(@resolution_proposal_params)
      put_update
    end

    it "redirects to the proposals page" do
      put_update
      response.should redirect_to('/proposals')
    end

    context "when the resolution proposal cannot be updated" do
      it "handles the error"
    end
  end

  describe "PUT pass" do
    before(:each) do
      @resolution_proposals_association = mock("resolution proposals association")
      @organisation.stub(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      @resolution_proposals_association.stub(:find).and_return(@resolution_proposal)

      @resolution_proposal.stub(:force_passed=)
      @resolution_proposal.stub(:close!)
    end

    def put_pass
      put :pass, :id => '1'
    end

    it "finds the resolution proposal" do
      @resolution_proposals_association.should_receive(:find).with('1').and_return(@resolution_proposal)
      put_pass
    end

    it "forces the resolution proposal to pass" do
      @resolution_proposal.should_receive(:force_passed=).with(true)
      put_pass
    end

    it "closes the resolution proposal" do
      @resolution_proposal.should_receive(:close!)
      put_pass
    end

    it "redirects to the proposals page" do
      put_pass
      response.should redirect_to('/proposals')
    end

    it "checks authorisation"
  end
  
end
