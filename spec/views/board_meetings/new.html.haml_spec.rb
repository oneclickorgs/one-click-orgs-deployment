require 'spec_helper'

describe "board_meetings/new" do

  before(:each) do
    @board_meeting = mock_model(BoardMeeting).as_new_record
    assign(:board_meeting, @board_meeting)
  end

  it "renders a date select for 'happened_on'" do
    render
    rendered.should have_selector(:select, :name => "board_meeting[happened_on(1i)]")
    rendered.should have_selector(:select, :name => "board_meeting[happened_on(2i)]")
    rendered.should have_selector(:select, :name => "board_meeting[happened_on(3i)]")
  end

  it "renders a 'start_time' field" do
    render
    rendered.should have_selector(:input, :name => "board_meeting[start_time]")
  end

  it "renders a 'venue' field" do
    render
    rendered.should have_selector(:textarea, :name => "board_meeting[venue]")
  end

  it "renders an 'agenda' field" do
    render
    rendered.should have_selector(:textarea, :name => "board_meeting[agenda]")
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
