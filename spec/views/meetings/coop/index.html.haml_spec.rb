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
  end

  it "renders a button link to the new general meeting page" do
    render
    rendered.should have_selector(:input, 'data-url' => '/general_meetings/new')
  end

  it "renders a list of the upcoming meetings" do
    render
    rendered.should have_selector('.upcoming_meetings #general_meeting_1')
  end

end
