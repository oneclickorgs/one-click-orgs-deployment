require 'spec_helper'

describe GeneralMeetingsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    before(:each) do
      @general_meetings_association = mock("general meetings association")
      @resolutions_association = mock("resolutions association")  
      @draft_resolutions_association = mock("draft resolutions association")

      @organisation.stub(:general_meetings).and_return(@general_meetings_association)
      @general_meetings_association.stub(:build)
      @organisation.stub(:resolutions).and_return(@resolutions_association)
      @resolutions_association.stub(:draft).and_return(@draft_resolutions_association)

      @organisation.stub(:directors_retiring)
    end

    def get_new
      get :new
    end

    it "finds the draft resolutions" do
      @resolutions_association.should_receive(:draft).and_return(@draft_resolutions_association)
      get_new
    end

    it "assigns the draft resolutions" do
      get_new
      assigns[:draft_resolutions].should == @draft_resolutions_association
    end

    it "finds the directors due to retire" do
      @organisation.should_receive(:directors_retiring).and_return(@directors_retiring)
      get_new
    end

    it "assigns the directors due to retire" do
      get_new
      assigns[:directors_retiring].should == @directors_retiring
    end
  end

  describe "POST create" do
    before(:each) do
      @general_meeting = mock_model(GeneralMeeting)
      @general_meeting_params = {'venue' => 'Meeting Hall'}

      @general_meeting.stub(:save!)
      @organisation.stub(:build_general_meeting_or_annual_general_meeting).and_return(@general_meeting)
    end

    def post_create
      post :create, 'general_meeting' => @general_meeting_params
    end

    it "builds a new General Meeting or Annual General Meeting" do
      @coop.should_receive(:build_general_meeting_or_annual_general_meeting).with(@general_meeting_params).and_return(@general_meeting)
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
