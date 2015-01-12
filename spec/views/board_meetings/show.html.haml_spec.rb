require 'rails_helper'

describe "board_meetings/show" do

  let(:board_meeting) {mock_model(BoardMeeting, :minutes => "We discussed things",
    :happened_on => 3.days.ago,
    :past? => true,
    :minuted? => true,
    :participants => []
  )}

  before(:each) do
    assign(:board_meeting, board_meeting)
    allow(view).to receive(:can?).and_return(false)
  end

  it "renders the minutes" do
    render
    expect(rendered).to have_content("We discussed things")
  end

end
