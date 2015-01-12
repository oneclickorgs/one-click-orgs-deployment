require 'spec_helper'

describe ChangeQuorumResolutionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    before(:each) do
      @change_quorum_resolution = mock_model(ChangeQuorumResolution)

      @change_quorum_resolutions_association = double("change-quorum resolutions association")
      allow(@change_quorum_resolutions_association).to receive(:build).and_return(@change_quorum_resolution)

      allow(@organisation).to receive(:change_quorum_resolutions).and_return(@change_quorum_resolutions_association)
    end

    def get_new
      get :new
    end

    it "builds a new change-quorum resolution" do
      expect(@change_quorum_resolutions_association).to receive(:build).and_return(@change_quorum_resolution)
      get_new
    end

    it "assigns the change-quorum resolution" do
      get_new
      expect(assigns[:change_quorum_resolution]).to eq(@change_quorum_resolution)
    end

    it "is successful" do
      get_new
      expect(response).to be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @change_quorum_resolution_params = {'quorum_number' => '5', 'quorum_percentage' => '30'}
      @change_quorum_resolutions_association = double("change-quorum resolutions association")
      @change_quorum_resolution = mock_model(ChangeQuorumResolution,
        :proposer= => nil,
        :draft= => nil,
        :save! => true
      )
      allow(@organisation).to receive(:change_quorum_resolutions).and_return(@change_quorum_resolutions_association)
      allow(@change_quorum_resolutions_association).to receive(:build).and_return(@change_quorum_resolution)
    end

    def post_create
      post :create, 'change_quorum_resolution' => @change_quorum_resolution_params
    end

    it "builds the resolution" do
      expect(@change_quorum_resolutions_association).to receive(:build).with(@change_quorum_resolution_params).and_return(@change_quorum_resolution)
      post_create
    end

    it "sets the proposer to the current user" do
      expect(@change_quorum_resolution).to receive(:proposer=).with(@user)
      post_create
    end

    it "sets the resolution as a draft" do
      expect(@change_quorum_resolution).to receive(:draft=).with(true)
      post_create
    end

    it "saves the resolution" do
      expect(@change_quorum_resolution).to receive(:save!)
      post_create
    end

    it "redirects to the meetings page" do
      post_create
      expect(response).to redirect_to('/meetings')
    end

    it "sets a notice flash mentioning the resolution" do
      post_create
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to contain('resolution')
    end
  end

end
