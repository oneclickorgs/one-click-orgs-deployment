require 'rails_helper'

describe 'minutes/new' do

  let(:minute) {mock_model(Minute,
    :meeting_class => nil,
    :happened_on => nil,
    :minutes => nil,
    :participant_ids => []
  ).as_new_record}
  let(:meeting_class_options_for_select) {[
    ['General Meeting', 'GeneralMeeting'],
    ['Annual General Meeting', 'AnnualGeneralMeeting'],
    ['Board Meeting', 'BoardMeeting']
  ]}
  let(:members) {[
    mock_model(Member, :name => "John Smith", :id => 1),
    mock_model(Member, :name => "Sally Baker", :id => 2)
  ]}

  before(:each) do
    assign(:minute, minute)
    assign(:meeting_class_options_for_select, meeting_class_options_for_select)
    assign(:members, members)
  end

  it "renders a select field for the type of minute" do
    render
    expect(rendered).to have_selector(:select, :name => 'minute[meeting_class]') do |select|
      expect(select).to have_selector(:option, :content => "General Meeting", :value => "GeneralMeeting")
      expect(select).to have_selector(:option, :content => "Annual General Meeting", :value => "AnnualGeneralMeeting")
      expect(select).to have_selector(:option, :content => "Board Meeting", :value => "BoardMeeting")
    end
  end

  it "renders a field to select the date of the minute" do
    render
    expect(rendered).to have_selector(:select, :name => 'minute[happened_on(1i)]')
    expect(rendered).to have_selector(:select, :name => 'minute[happened_on(2i)]')
    expect(rendered).to have_selector(:select, :name => 'minute[happened_on(3i)]')
  end

  it "renders a minutes field" do
    render
    expect(rendered).to have_selector(:textarea, :name => 'minute[minutes]')
  end

  it "renders a checkbox for each member" do
    render

    expect(rendered).to have_selector(:input, :type => 'checkbox', :name => 'minute[participant_ids][1]')
    expect(rendered).to have_selector(:label, :for => 'minute_participant_ids_1', :content => "John Smith")

    expect(rendered).to have_selector(:input, :type => 'checkbox', :name => 'minute[participant_ids][2]')
    expect(rendered).to have_selector(:label, :for => 'minute_participant_ids_2', :content => "Sally Baker")
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector(:input, :type => 'submit')
  end

end
