require 'rails_helper'

describe 'meetings/coop/index' do

  before(:each) do
    @upcoming_meeting = mock_model(GeneralMeeting,
      :happened_on => Date.new(2012, 8, 1),
      :start_time => "4pm",
      :venue => "The Meeting Hall",
      :id => 1
    )
    assign(:upcoming_meetings, [@upcoming_meeting])

    allow(view).to receive(:can?).and_return(false)

    @organisation = mock_model(Coop)
    allow(view).to receive(:co).and_return(@organisation)

    @constitution = double("constitution",
      :meeting_notice_period => 14,
      :quorum_number => 3,
      :quorum_percentage => 25
    )
    allow(@organisation).to receive(:constitution).and_return(@constitution)
  end

  context "when user can create Meetings" do
    before(:each) do
      allow(view).to receive(:can?).with(:create, Meeting).and_return(true)
    end

    it "renders a button link to the new general meeting page" do
      render
      expect(rendered).to have_selector("form[action='/general_meetings/new']")
    end

    it "renders a link to enter minutes for a meeting not yet in the system" do
      render
      expect(rendered).to have_selector("a[href='/minutes/new']")
    end
  end

  context "when user cannot create Meetings" do
    before(:each) do
      allow(view).to receive(:can?).with(:create, Meeting).and_return(false)
    end

    it "renders a link to create a new GeneralMeetingProposal" do
      render
      expect(rendered).to have_selector("a[href='/general_meeting_proposals/new']")
    end
  end

  it "renders a list of the upcoming meetings" do
    render
    expect(rendered).to have_selector('.upcoming_meetings #general_meeting_1')
  end

  context "when a past meeting has no minutes" do
    before(:each) do
      @past_meeting = mock_model(GeneralMeeting, :to_param => '2', :happened_on => 1.day.ago, :minuted? => false)
      assign(:past_meetings, [@past_meeting])
    end

    it "renders a message that the past meeting has no minutes" do
      render
      expect(rendered).to have_selector('.past_meetings') do |past_meetings|
        expect(past_meetings).to have_content('Minutes have not been entered')
      end
    end

    context "when user can create Meetings" do
      before(:each) do
        allow(view).to receive(:can?).with(:create, Meeting).and_return(true)
      end

      it "renders a link to edit the meeting" do
        render
        expect(rendered).to have_selector("a[href='/general_meetings/2/edit']")
      end
    end
  end

  context "when a past meeting has minutes" do
    before(:each) do
      @past_meeting = mock_model(GeneralMeeting, :to_param => '2', :minutes => "Minutes", :happened_on => 1.day.ago, :minuted? => true)
      assign(:past_meetings, [@past_meeting])
    end

    it "renders a link to show the meeting" do
      render
      expect(rendered).to have_selector("a[href='/general_meetings/2']")
    end
  end

end
