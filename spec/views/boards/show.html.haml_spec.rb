require 'rails_helper'

describe "boards/show" do

  let(:upcoming_meetings) {[mock_model(BoardMeeting,
    :happened_on => Date.new(2012, 9, 1),
    :venue => "The Meeting Hall"
  )]}
  let(:proposals) {[mock_model(BoardResolution,
    :title => "This is an open proposal",
    :end_date => 1.day.from_now,
    :vote_by => false
  )]}
  let(:draft_proposals) {[mock_model(BoardResolution, :title => "This is a draft proposal")]}
  let(:user) {mock_model(Member)}

  before(:each) do
    assign(:upcoming_meetings, upcoming_meetings)
    assign(:proposals, proposals)
    assign(:draft_proposals, draft_proposals)

    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:can?).and_return(true)
  end

  it "renders a button to create a new board meeting" do
    render
    expect(rendered).to have_selector(:form, :action => '/board_meetings/new')
  end

  it "renders a button to create a new board resolution" do
    render
    expect(rendered).to have_selector(:form, :action => '/board_resolutions/new')
  end

  it "renders a list of upcoming board meetings" do
    render
    expect(rendered).to have_selector('.upcoming_meetings') do |upcoming_meetings|
      expect(upcoming_meetings).to have_content("1 September 2012")
      expect(upcoming_meetings).to have_content("The Meeting Hall")
    end
  end

  it "renders a list of open board resolutions" do
    render
    expect(rendered).to have_selector('.proposals') do |open_proposals|
      expect(open_proposals).to have_content("This is an open proposal")
    end
  end

  it "renders a list of draft board resolutions" do
    render
    expect(rendered).to have_selector('.draft_proposals') do |draft_proposals|
      expect(draft_proposals).to have_content("This is a draft proposal")
    end
  end

  context "when a past board meeting has no minutes" do
    before(:each) do
      @past_meeting = mock_model(BoardMeeting, :happened_on => 3.days.ago, :to_param => '2')
      allow(@past_meeting).to receive(:minuted?).and_return(false)
      assign(:past_meetings, [@past_meeting])
    end

    it "renders a message that the past board meeting has no minutes" do
      render
      expect(rendered).to have_selector(".past_meetings") do |past_meetings|
        expect(past_meetings).to have_content("Minutes have not been entered for this meeting yet")
      end
    end

    context "when the user can update the meeting" do
      before(:each) do
        allow(view).to receive(:can?).with(:update, @past_meeting).and_return(true)
      end

      it "renders a link to edit the meeting" do
        render
        expect(rendered).to have_selector(:a, :href => '/board_meetings/2/edit')
      end
    end
  end

  context "when a past board meeting has minutes" do
    let(:past_meeting) {mock_model(BoardMeeting, :happened_on => 3.days.ago, :to_param => '2')}

    before(:each) do
      allow(past_meeting).to receive(:minuted?).and_return(true)
      assign(:past_meetings, [past_meeting])
    end

    it "renderes a link to view the meeting's minutes" do
      render
      expect(rendered).to have_selector(:a, :href => "/board_meetings/2")
    end
  end

end
