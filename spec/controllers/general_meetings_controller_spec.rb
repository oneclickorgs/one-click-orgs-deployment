require 'spec_helper'

describe GeneralMeetingsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "POST create" do
    before(:each) do
      @general_meetings_association = mock("general meetings association")
      @organisation.stub(:general_meetings).and_return(@general_meetings_association)

      @general_meeting = mock_model(GeneralMeeting)
      @general_meetings_association.stub(:build).and_return(@general_meeting)

      @general_meeting.stub(:save!)

      @general_meeting_params = {'venue' => 'Meeting Hall'}
    end

    def post_create
      post :create, 'general_meeting' => @general_meeting_params
    end

    it "builds the new meeting" do
      @general_meetings_association.should_receive(:build).with(@general_meeting_params).and_return(@general_meeting)
      post_create
    end

    it "saves the new meeting" do
      @general_meeting.should_receive(:save!)
      post_create
    end

    it "redirects to the meetings page" do
      post_create
      response.should redirect_to('/meetings')
    end

    context "when the new meeting cannot be saved" do
      it "handles the error"
    end
  end

end
