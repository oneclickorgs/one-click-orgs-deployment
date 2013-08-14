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
      @general_meetings_association = double("general meetings association")
      @resolutions_association = double("resolutions association")
      @draft_resolutions_association = double("draft resolutions association")

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
    let(:general_meetings) {double("general meetings")}

    before(:each) do
      @general_meeting = mock_model(GeneralMeeting)
      @general_meeting_params = {'venue' => 'Meeting Hall'}

      @general_meeting.stub(:save!)
      @organisation.stub(:general_meetings).and_return(general_meetings)
      general_meetings.stub(:build).and_return(@general_meeting)
    end

    def post_create
      post :create, 'general_meeting' => @general_meeting_params
    end

    it "builds a new General Meeting or Annual General Meeting" do
      general_meetings.should_receive(:build).with(@general_meeting_params).and_return(@general_meeting)
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

  describe "GET show" do
    let(:general_meetings) {double("general_meetings association", :find => general_meeting)}
    let(:general_meeting) {mock_model("GeneralMeeting")}

    before(:each) do
      @organisation.stub(:general_meetings).and_return(general_meetings)
    end

    def get_show
      get :show, 'id' => '1'
    end

    it "finds the general meeting" do
      general_meetings.should_receive(:find).with('1').and_return(general_meeting)
      get_show
    end

    it "assigns the general meeting" do
      get_show
      assigns[:general_meeting].should == general_meeting
    end

    it "is successful" do
      get_show
      response.should be_success
    end
  end

  describe "GET edit" do
    let(:general_meeting){mock_model(GeneralMeeting)}
    let(:general_meetings){double("general_meetings association", :find => general_meeting)}
    let(:members){double("members association", :map => nil)}

    before(:each) do
      @organisation.stub(:general_meetings).and_return(general_meetings)
      @organisation.stub(:members).and_return(members)
    end

    def get_edit
      get :edit, :id => '1'
    end

    it "finds the general meeting" do
      general_meetings.should_receive(:find).with('1').and_return(general_meeting)
      get_edit
    end

    it "assigns the general meeting" do
      get_edit
      assigns[:general_meeting].should == general_meeting
    end

    it "assigns the members" do
      get_edit
      assigns[:members].should == members
    end

    it "is successful" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT update" do
    let(:general_meetings){double("general_meetings association", :find => general_meeting)}
    let(:general_meeting){mock_model(GeneralMeeting, :update_attributes => true)}
    let(:general_meeting_params){{'minutes' => 'We discussed things.'}}

    before(:each) do
      @organisation.stub(:general_meetings).and_return(general_meetings)
    end

    def put_update
      put :update, 'id' => '1', 'general_meeting' => general_meeting_params
    end

    it "finds the general meeting" do
      general_meetings.should_receive(:find).with('1').and_return(general_meeting)
      put_update
    end

    it "updates the general meeting's attributes" do
      general_meeting.should_receive(:update_attributes).with(general_meeting_params).and_return(true)
      put_update
    end

    it "redirects" do
      put_update
      response.should be_redirect
    end

    context "when updating the general meeting's attributes fails" do
      it "handles the error"
    end
  end

end
