require 'spec_helper'

describe "general_meetings/new" do

  before(:each) do
    @general_meeting = mock_model(GeneralMeeting,
      :certification => nil,
      :existing_resolutions_attributes= => nil,
      :annual_general_meeting => nil,
      :electronic_nominations => nil,
      :nominations_closing_date => nil,
      :electronic_voting => nil,
      :voting_closing_date => nil,
      :start_time_proxy => nil
    ).as_new_record
    assign(:general_meeting, @general_meeting)

    @draft_resolutions = [
      mock_model(Resolution, :state => 'draft', :id => 111, :attached => nil),
      mock_model(Resolution, :state => 'draft', :id => 222, :attached => nil)
    ]
    assign(:draft_resolutions, @draft_resolutions)

    @directors_retiring = [
      mock_model(Director, :name => "Sally Baker"),
      mock_model(Director, :name => "John Smith")
    ]
  end

  it "renders time select fields for the start_time attribute" do
    render
    rendered.should have_selector(:select, :name => 'general_meeting[start_time_proxy(4i)]')
    rendered.should have_selector(:select, :name => 'general_meeting[start_time_proxy(5i)]')
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

  it "renders a check box for the AGM" do
    render
    rendered.should have_selector(:input,
      :name => 'general_meeting[annual_general_meeting]',
      :type => 'checkbox',
      :value => '1'
    )
  end

  it "renders a list of directors to retire" do
    render
    rendered.should have_selector('ul.directors') do |ul|
      ul.should contain("Sally Baker")
      ul.should contain("John Smith")
    end
  end

  it "renders an 'electronic_nominations' field" do
    render
    rendered.should have_selector(:input, :name => 'general_meeting[electronic_nominations]')
  end

  it "renders a date select for nominations_closing_date" do
    render
    rendered.should have_selector(:select, :name => 'general_meeting[nominations_closing_date(1i)]')
    rendered.should have_selector(:select, :name => 'general_meeting[nominations_closing_date(2i)]')
    rendered.should have_selector(:select, :name => 'general_meeting[nominations_closing_date(3i)]')
  end

  it "renders an 'electronic_voting' field" do
    render
    rendered.should have_selector(:input, :name => 'general_meeting[electronic_voting]')
  end

  it "renders a date select for voting_closing_date" do
    render
    rendered.should have_selector(:select, :name => 'general_meeting[voting_closing_date(1i)]')
    rendered.should have_selector(:select, :name => 'general_meeting[voting_closing_date(2i)]')
    rendered.should have_selector(:select, :name => 'general_meeting[voting_closing_date(3i)]')
  end

end
