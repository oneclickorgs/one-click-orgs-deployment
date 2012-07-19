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

      @change_quorum_resolutions_association = mock("change-quorum resolutions association")  
      @change_quorum_resolutions_association.stub(:build).and_return(@change_quorum_resolution)

      @organisation.stub(:change_quorum_resolutions).and_return(@change_quorum_resolutions_association)
    end

    def get_new
      get :new
    end

    it "builds a new change-quorum resolution" do
      @change_quorum_resolutions_association.should_receive(:build).and_return(@change_quorum_resolution)
      get_new
    end

    it "assigns the change-quorum resolution" do
      get_new
      assigns[:change_quorum_resolution].should == @change_quorum_resolution
    end

    it "is successful" do
      get_new
      response.should be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @change_quorum_resolution_params = {'quorum_number' => '5', 'quorum_percentage' => '30'}
      @change_quorum_resolutions_association = mock("change-quorum resolutions association")
      @change_quorum_resolution = mock_model(ChangeQuorumResolution,
        :proposer= => nil,
        :draft= => nil,
        :save! => true
      )
      @organisation.stub(:change_quorum_resolutions).and_return(@change_quorum_resolutions_association)
      @change_quorum_resolutions_association.stub(:build).and_return(@change_quorum_resolution)
    end

    def post_create
      post :create, 'change_quorum_resolution' => @change_quorum_resolution_params
    end

    it "builds the resolution" do
      @change_quorum_resolutions_association.should_receive(:build).with(@change_quorum_resolution_params).and_return(@change_quorum_resolution)
      post_create
    end

    it "sets the proposer to the current user" do
      @change_quorum_resolution.should_receive(:proposer=).with(@user)
      post_create
    end

    it "sets the resolution as a draft" do
      @change_quorum_resolution.should_receive(:draft=).with(true)
      post_create
    end

    it "saves the resolution" do
      @change_quorum_resolution.should_receive(:save!)
      post_create
    end

    it "redirects to the meetings page" do
      post_create
      response.should redirect_to('/meetings')
    end

    it "sets a notice flash mentioning the resolution" do
      post_create
      flash[:notice].should be_present
      flash[:notice].should contain('resolution')
    end
  end

end
