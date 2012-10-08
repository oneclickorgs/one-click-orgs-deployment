require 'spec_helper'

describe "boards/show" do

  let(:upcoming_meetings) {[mock_model(BoardMeeting,
    :happened_on => Date.new(2012, 9, 1),
    :venue => "The Meeting Hall"
  )]}

  before(:each) do
    assign(:upcoming_meetings, upcoming_meetings)
  end

  it "renders a button to create a new board meeting" do
    render
    rendered.should have_selector(:input, 'data-url' => '/board_meetings/new')
  end

  it "renders a list of upcoming board meetings" do
    render
    rendered.should have_selector('.upcoming_meetings') do |upcoming_meetings|
      upcoming_meetings.should have_content("1 September 2012")
      upcoming_meetings.should have_content("The Meeting Hall")
    end
  end

end
