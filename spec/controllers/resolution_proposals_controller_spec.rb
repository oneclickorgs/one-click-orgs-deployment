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
      @resolution_proposals_association = double("resolution proposals association")
      allow(@organisation).to receive(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      allow(@resolution_proposals_association).to receive(:build).and_return(@resolution_proposal)
    end

    it "builds a new resolution proposal" do
      expect(@resolution_proposals_association).to receive(:build).and_return(@resolution_proposal)
      get :new
    end

    it "assigns the new resolution proposal" do
      get :new
      expect(assigns[:resolution_proposal]).to eq(@resolution_proposal)
    end

    it "succeeds" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST create" do
    before(:each) do
      @resolution_proposal_params = {'description' => 'Buy more sporks.'}
      @resolution_proposals_association = double("resolution proposals association")
      @resolution_proposal = mock_model(ResolutionProposal, :to_param => '50')
      allow(@organisation).to receive(:resolution_proposals).and_return(@resolution_proposals_association)
      allow(@resolution_proposals_association).to receive(:build).and_return(@resolution_proposal)
      allow(@resolution_proposal).to receive(:proposer=)
      allow(@resolution_proposal).to receive(:save!)
    end

    def post_create
      post :create, 'resolution_proposal' => @resolution_proposal_params
    end

    it "builds the new resolution proposal" do
      expect(@resolution_proposals_association).to receive(:build).with(@resolution_proposal_params).and_return(@resolution_proposal)
      post_create
    end

    it "assigns the current user as the proposer" do
      expect(@resolution_proposal).to receive(:proposer=).with(@user)
      post_create
    end

    it "saves the new resolution proposal" do
      expect(@resolution_proposal).to receive(:save!)
      post_create
    end

    it "redirects to the new proposal page" do
      post_create
      expect(response).to redirect_to('/resolution_proposals/50')
    end

    context "when the new resolution proposal cannot be saved" do
      it "handles the error"
    end
  end

  describe "GET edit" do
    before(:each) do
      @resolution_proposals_association = double("resolution proposals association")
      allow(@organisation).to receive(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      allow(@resolution_proposals_association).to receive(:find).and_return(@resolution_proposal)
    end

    def get_edit
      get :edit, :id => '1'
    end

    it "finds the resolution proposal" do
      expect(@resolution_proposals_association).to receive(:find).with('1').and_return(@resolution_proposal)
      get_edit
    end

    it "assigns the resolution proposal" do
      get_edit
      expect(assigns[:resolution_proposal]).to eq(@resolution_proposal)
    end

    it "is successful" do
      get_edit
      expect(response).to be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      @resolution_proposal_params = {'description' => 'New description.'}

      @resolution_proposals_association = double("resolution proposals association")
      allow(@organisation).to receive(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      allow(@resolution_proposals_association).to receive(:find).and_return(@resolution_proposal)

      allow(@resolution_proposal).to receive(:update_attributes)
    end

    def put_update
      put :update, 'id' => '1', 'resolution_proposal' => @resolution_proposal_params
    end

    it "finds the resolution proposal" do
      expect(@resolution_proposals_association).to receive(:find).with('1').and_return(@resolution_proposal)
      put_update
    end

    it "updates the resolution proposal's attributes" do
      expect(@resolution_proposal).to receive(:update_attributes).with(@resolution_proposal_params)
      put_update
    end

    it "redirects to the proposals page" do
      put_update
      expect(response).to redirect_to('/proposals')
    end

    context "when the resolution proposal cannot be updated" do
      it "handles the error"
    end
  end

  describe "PUT pass" do
    before(:each) do
      @resolution_proposals_association = double("resolution proposals association")
      allow(@organisation).to receive(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      allow(@resolution_proposals_association).to receive(:find).and_return(@resolution_proposal)

      allow(@resolution_proposal).to receive(:force_passed=)
      allow(@resolution_proposal).to receive(:close!)
    end

    def put_pass
      put :pass, :id => '1'
    end

    it "finds the resolution proposal" do
      expect(@resolution_proposals_association).to receive(:find).with('1').and_return(@resolution_proposal)
      put_pass
    end

    it "forces the resolution proposal to pass" do
      expect(@resolution_proposal).to receive(:force_passed=).with(true)
      put_pass
    end

    it "closes the resolution proposal" do
      expect(@resolution_proposal).to receive(:close!)
      put_pass
    end

    it "redirects to the proposals page" do
      put_pass
      expect(response).to redirect_to('/proposals')
    end

    it "checks authorisation"
  end

  describe "PUT pass_to_meeting" do
    before(:each) do
      @resolution_proposals_association = double("resolution proposals association")
      allow(@organisation).to receive(:resolution_proposals).and_return(@resolution_proposals_association)

      @resolution_proposal = mock_model(ResolutionProposal)
      allow(@resolution_proposals_association).to receive(:find).and_return(@resolution_proposal)

      @resolution = mock_model(Resolution, :to_param => '2')

      allow(@resolution_proposal).to receive(:force_passed=)
      allow(@resolution_proposal).to receive(:create_draft_resolution=)
      allow(@resolution_proposal).to receive(:close!)
      allow(@resolution_proposal).to receive(:new_resolution).and_return(@resolution)
    end

    def put_pass_to_meeting
      put :pass_to_meeting, :id => '1'
    end

    it "finds the resolution proposal" do
      expect(@resolution_proposals_association).to receive(:find).with('1').and_return(@resolution_proposal)
      put_pass_to_meeting
    end

    it "forces the resolution proposal to pass" do
      expect(@resolution_proposal).to receive(:force_passed=).with(true)
      put_pass_to_meeting
    end

    it "instructs the resolution proposal to create a draft proposal" do
      expect(@resolution_proposal).to receive(:create_draft_resolution=).with(true)
      put_pass_to_meeting
    end

    it "closes the resolution proposal" do
      expect(@resolution_proposal).to receive(:close!)
      put_pass_to_meeting
    end

    it "fetches the new resolution" do
      expect(@resolution_proposal).to receive(:new_resolution).and_return(@resolution)
      put_pass_to_meeting
    end

    it "redirects to the new general meeting page with the new resolution ID" do
      put_pass_to_meeting
      expect(response).to redirect_to('/general_meetings/new?resolution_id=2')
    end
  end

end
