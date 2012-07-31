require 'spec_helper'

describe "general_meetings/new" do

  before(:each) do
    @general_meeting = mock_model(GeneralMeeting,
      :certification => nil,
      :existing_resolutions_attributes= => nil
    ).as_new_record
    assign(:general_meeting, @general_meeting)

    @draft_resolutions = [
      mock_model(Resolution, :state => 'draft', :id => 111, :attached => nil),
      mock_model(Resolution, :state => 'draft', :id => 222, :attached => nil)
    ]
    assign(:draft_resolutions, @draft_resolutions)
  end

  it "renders check boxes to attach draft resolutions to the new meeting" do
    render
    rendered.should have_selector(:input,
      :name => 'general_meeting[existing_resolutions_attributes][0][attached]',
      :type => 'checkbox',
      :value => '1'
    )
  end

  it "renders a hidden field with the ID of each draft resolution" do
    render
    rendered.should have_selector(:input,
      :name => 'general_meeting[existing_resolutions_attributes][0][id]',
      :value => '111',
      :type => 'hidden'
    )
  end

end
