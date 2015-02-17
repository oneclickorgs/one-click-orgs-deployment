require 'rails_helper'

describe "board_meetings/new" do

  before(:each) do
    @board_meeting = mock_model(BoardMeeting).as_new_record
    assign(:board_meeting, @board_meeting)
  end

  it "renders a date select for 'happened_on'" do
    render
    expect(rendered).to have_selector("select[name='board_meeting[happened_on(1i)]']")
    expect(rendered).to have_selector("select[name='board_meeting[happened_on(2i)]']")
    expect(rendered).to have_selector("select[name='board_meeting[happened_on(3i)]']")
  end

  it "renders a 'start_time' field" do
    render
    expect(rendered).to have_selector("input[name='board_meeting[start_time]']")
  end

  it "renders a 'venue' field" do
    render
    expect(rendered).to have_selector("textarea[name='board_meeting[venue]']")
  end

  it "renders an 'agenda' field" do
    render
    expect(rendered).to have_selector("textarea[name='board_meeting[agenda]']")
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector("input[type='submit']")
  end

end
