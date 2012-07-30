require 'spec_helper'

describe 'meetings/coop/index' do

  before(:each) do
    @upcoming_meeting = mock_model(GeneralMeeting,
      :happened_on => Date.new(2012, 8, 1),
      :start_time => "4pm",
      :venue => "The Meeting Hall",
      :id => 1
    )
    assign(:upcoming_meetings, [@upcoming_meeting])

    view.stub(:can?).and_return(false)

    @organisation = mock_model(Coop)
    view.stub(:co).and_return(@organisation)

    @constitution = mock("constitution",
      :meeting_notice_period => 14,
      :quorum_number => 3,
      :quorum_percentage => 25
    )
    @organisation.stub(:constitution).and_return(@constitution)
  end

  it "renders a button link to the new general meeting page" do
    render
    rendered.should have_selector(:input, 'data-url' => '/general_meetings/new')
  end

  it "renders a list of the upcoming meetings" do
    render
    rendered.should have_selector('.upcoming_meetings #general_meeting_1')
  end

  it "shows the current meeting notice period" do
    render
    rendered.should contain("The notice period for General Meetings is 14 clear days.")
  end

  context "when user can create meetings" do
    before(:each) do
      view.stub(:can?).with(:create, Meeting).and_return(true)
    end

    it "renders a button link to create a board meeting" do
      render
      rendered.should have_selector(:input, 'data-url' => '/board_meetings/new')
    end
  end

  context "when user can create resolutions" do
    before(:each) do
      view.stub(:can?).with(:create, Resolution).and_return(true)
    end

    it "renders a button link to change the notice period" do
      render
      rendered.should have_selector(:input, 'data-url' => '/change_meeting_notice_period_resolutions/new')
    end

    it "renders a button link to change the quorum" do
      render
      rendered.should have_selector(:input, 'data-url' => '/change_quorum_resolutions/new')
    end
  end

end
