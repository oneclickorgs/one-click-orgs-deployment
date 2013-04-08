require 'spec_helper'

describe "board_meetings/edit" do

  let(:board_meeting) {mock_model(BoardMeeting,
    :participant_ids => []
  )}
  let(:directors) {[
    mock_director,
    mock_director,
    mock_director
  ]}

  before(:each) do
    assign(:board_meeting, board_meeting)
    assign(:directors, directors)
  end

  it "renders a minutes text box" do
    render
    rendered.should have_selector(:textarea, :name => 'board_meeting[minutes]')
  end

  it "renders a participant checkbox for each director" do
    render
    directors.each do |director|
      rendered.should have_selector(:input, :name => "board_meeting[participant_ids][#{director.id}]")
      rendered.should have_selector(:label, :for => "board_meeting_participant_ids_#{director.id}", :content => director.name)
    end
  end

end
