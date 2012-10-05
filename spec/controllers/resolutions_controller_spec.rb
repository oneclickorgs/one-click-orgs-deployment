require 'spec_helper'

describe ResolutionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "POST create" do
    before(:each) do
      @resolution_params = {'description' => "Do things"}

      @resolutions_association = mock("resolutions association")
      @organisation.stub(:resolutions).and_return(@resolutions_association)

      @resolution = mock_model(Resolution, :save! => true, :proposer= => nil)

      @resolutions_association.stub(:build).and_return(@resolution)
    end

    def post_create
      post :create, 'resolution' => @resolution_params
    end

    it "builds the new resolution" do
      @resolutions_association.should_receive(:build).with(@resolution_params).and_return(@resolution)
      post_create
    end

    it "set the proposer to the current user" do
      @resolution.should_receive(:proposer=).with(@user)
      post_create
    end

    it "saves the new resolution" do
      @resolution.should_receive(:save!)
      post_create
    end

    it "redirects to the proposals page" do
      post_create
      response.should redirect_to('/proposals')
    end

    context "when saving the new resolution fails" do
      it "handles the error"
    end

    it "checks authorisation"
  end

end
