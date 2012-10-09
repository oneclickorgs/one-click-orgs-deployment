require 'spec_helper'

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

    view.stub(:current_user).and_return(user)
    view.stub(:can?).and_return(true)
  end

  it "renders a button to create a new board meeting" do
    render
    rendered.should have_selector(:input, 'data-url' => '/board_meetings/new')
  end

  it "renders a button to create a new board resolution" do
    render
    rendered.should have_selector(:input, 'data-url' => '/board_resolutions/new')
  end

  it "renders a list of upcoming board meetings" do
    render
    rendered.should have_selector('.upcoming_meetings') do |upcoming_meetings|
      upcoming_meetings.should have_content("1 September 2012")
      upcoming_meetings.should have_content("The Meeting Hall")
    end
  end

  it "renders a list of open board resolutions" do
    render
    rendered.should have_selector('.proposals') do |open_proposals|
      open_proposals.should have_content("This is an open proposal")
    end
  end

  it "renders a list of draft board resolutions" do
    render
    rendered.should have_selector('.draft_proposals') do |draft_proposals|
      draft_proposals.should have_content("This is a draft proposal")
    end
  end

end
