require 'spec_helper'

describe ChangeMeetingNoticePeriodResolutionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    before(:each) do
      @change_meeting_notice_period_resolution = mock_model(ChangeMeetingNoticePeriodResolution)

      @change_meeting_notice_period_resolutions_association = mock("change-meeting-notice-period resolutions association")
      @organisation.stub(:change_meeting_notice_period_resolutions).and_return(@change_meeting_notice_period_resolutions_association)

      @change_meeting_notice_period_resolutions_association.stub(:build).and_return(@change_meeting_notice_period_resolution)
    end

    def get_new
      get :new
    end

    it "builds a new resolution" do
      @change_meeting_notice_period_resolutions_association.should_receive(:build).and_return(@change_meeting_notice_period_resolution)
      get_new
    end

    it "assigns the new resolution" do
      get_new
      assigns[:change_meeting_notice_period_resolution].should == @change_meeting_notice_period_resolution
    end
  end

  describe "POST create" do
    before(:each) do
      @resolutions_association = mock("change-meeting-notice-period resolutions association")
      @resolution_params = {'meeting_notice_period' => '28'}
      @resolution = mock_model("ChangeMeetingNoticePeriodResolution",
        :proposer= => nil,
        :save! => true
      )

      @organisation.stub(:change_meeting_notice_period_resolutions).and_return(@resolutions_association)
      @resolutions_association.stub(:build).and_return(@resolution)
    end

    def post_create
      post :create, 'change_meeting_notice_period_resolution' => @resolution_params
    end

    it "builds the new resolution" do
      @resolutions_association.should_receive(:build).with(@resolution_params).and_return(@resolution)
      post_create
    end

    it "sets the proposer to the current user" do
      @resolution.should_receive(:proposer=).with(@user)
      post_create
    end

    it "saves the resolution" do
      @resolution.should_receive(:save!)
      post_create
    end

    it "redirects to the meetings page" do
      post_create
      response.should redirect_to('/meetings')
    end

    context "when the resolution cannot be saved" do
      it "handles the error"
    end
  end

end
