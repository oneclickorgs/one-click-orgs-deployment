require 'spec_helper'

describe BoardResolutionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    before(:each) do
      @board_resolution = mock_model(BoardResolution)

      @board_resolutions_association = double("board resolutions association")
      @board_resolutions_association.stub(:build).and_return(@board_resolution)

      @organisation.stub(:board_resolutions).and_return(@board_resolutions_association)
    end

    it "builds a new board resolution" do
      @board_resolutions_association.should_receive(:build).and_return(@board_resolution)
      get :new
    end

    it "is successful" do
      get :new
      response.should be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @board_resolution = mock_model(BoardResolution, :proposer= => nil, :save! => true)

      @board_resolutions_association = double("board resolutions association")
      @organisation.stub(:board_resolutions).and_return(@board_resolutions_association)

      @board_resolutions_association.stub(:build).and_return(@board_resolution)

      @board_resolution_params = {'description' => "We should buy more chairs."}
    end

    def post_create
      post :create, 'board_resolution' => @board_resolution_params
    end

    it "builds the new board resolution" do
      @board_resolutions_association.should_receive(:build).with(@board_resolution_params).and_return(@board_resolution)
      post_create
    end

    it "assigns the proposer to be the current user" do
      @board_resolution.should_receive(:proposer=).with(@user)
      post_create
    end

    it "saves the new board resolution" do
      @board_resolution.should_receive(:save!)
      post_create
    end

    it "redirects to the Board page" do
      post_create
      response.should redirect_to('/board')
    end

    context "when the board resolution fails to be saved" do
      it "handles the error"
    end
  end

end
