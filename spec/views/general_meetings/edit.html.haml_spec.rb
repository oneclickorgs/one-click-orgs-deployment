require 'spec_helper'

describe 'general_meetings/edit' do

  let(:general_meeting) {mock_model(GeneralMeeting)}
  let(:members) {[
    mock_model(Member, :id => 1, :name => "John Smith"),
    mock_model(Member, :id => 2, :name => "Sally Baker")
  ]}

  before(:each) do
    assign(:general_meeting, general_meeting)
    assign(:members, members)
  end

  it "renders a minutes text area" do
    render
    rendered.should have_selector(:textarea, :name => 'general_meeting[minutes]')
  end

  it "renders a checkbox for each member" do
    render

    rendered.should have_selector(:input, :type => 'checkbox', :name => 'general_meeting[participant_ids][1]')
    rendered.should have_selector(:label, :for => 'general_meeting_participant_ids_1', :content => "John Smith")

    rendered.should have_selector(:input, :type => 'checkbox', :name => 'general_meeting[participant_ids][2]')
    rendered.should have_selector(:label, :for => 'general_meeting_participant_ids_2', :content => "Sally Baker")
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
