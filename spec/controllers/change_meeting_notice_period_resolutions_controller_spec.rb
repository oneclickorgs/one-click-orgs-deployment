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

      @change_meeting_notice_period_resolutions_association = double("change-meeting-notice-period resolutions association")
      allow(@organisation).to receive(:change_meeting_notice_period_resolutions).and_return(@change_meeting_notice_period_resolutions_association)

      allow(@change_meeting_notice_period_resolutions_association).to receive(:build).and_return(@change_meeting_notice_period_resolution)
    end

    def get_new
      get :new
    end

    it "builds a new resolution" do
      expect(@change_meeting_notice_period_resolutions_association).to receive(:build).and_return(@change_meeting_notice_period_resolution)
      get_new
    end

    it "assigns the new resolution" do
      get_new
      expect(assigns[:change_meeting_notice_period_resolution]).to eq(@change_meeting_notice_period_resolution)
    end
  end

  describe "POST create" do
    before(:each) do
      @resolutions_association = double("change-meeting-notice-period resolutions association")
      @resolution_params = {'meeting_notice_period' => '28'}
      @resolution = mock_model("ChangeMeetingNoticePeriodResolution",
        :proposer= => nil,
        :draft= => nil,
        :accepted? => false,
        :save! => true,
        :notice_period_increased? => true
      )

      allow(@organisation).to receive(:change_meeting_notice_period_resolutions).and_return(@resolutions_association)
      allow(@resolutions_association).to receive(:build).and_return(@resolution)
    end

    def post_create
      post :create, 'change_meeting_notice_period_resolution' => @resolution_params
    end

    it "builds the new resolution" do
      expect(@resolutions_association).to receive(:build).with(@resolution_params).and_return(@resolution)
      post_create
    end

    it "sets the proposer to the current user" do
      expect(@resolution).to receive(:proposer=).with(@user)
      post_create
    end

    it "sets the resolution as a draft" do
      expect(@resolution).to receive(:draft=).with(true)
      post_create
    end

    it "saves the resolution" do
      expect(@resolution).to receive(:save!)
      post_create
    end

    it "redirects to the meetings page" do
      post_create
      expect(response).to redirect_to('/meetings')
    end

    context "when the resolution does not pass immediately" do
      before(:each) do
        allow(@resolution).to receive(:accepted?).and_return(false)
      end

      it "sets a notice flash mentioning the resolution" do
        post_create
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to include('resolution')
      end

      context "when notice period is being increased" do
        before(:each) do
          allow(@resolution).to receive(:notice_period_increased?).and_return(true)
        end

        it "sets a notice flash mentioning the increase" do
          post_create
          expect(flash[:notice]).to include('increase')
        end
      end

      context "when the notice period is being decreased" do
        before(:each) do
          allow(@resolution).to receive(:notice_period_increased?).and_return(false)
        end

        it "sets a notice flash mentioning the decrease" do
          post_create
          expect(flash[:notice]).to include('decrease')
        end
      end
    end

    context "when the resolution does pass immediately" do
      before(:each) do
        allow(@resolution).to receive(:accepted?).and_return(true)
      end

      it "sets a notice flash" do
        post_create
        expect(flash[:notice]).to be_present
      end
    end

    context "when the resolution cannot be saved" do
      it "handles the error"
    end
  end

end
