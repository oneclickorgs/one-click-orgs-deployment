require 'rails_helper'

describe "annual_general_meetings/new" do

  let(:annual_general_meeting) {mock_model(AnnualGeneralMeeting,
    :start_time_proxy => nil,
    :electronic_nominations => nil,
    :electronic_voting => nil,
    :nominations_closing_date => nil,
    :voting_closing_date => nil
  )}
  let(:draft_resolutions) {[]}
  let(:directors_retiring) {[
    mock_model(Director, :name => "Sally Baker"),
    mock_model(Director, :name => "John Smith")
  ]}

  before(:each) do
    assign(:annual_general_meeting, annual_general_meeting)
    assign(:draft_resolutions, draft_resolutions)
    assign(:directors_retiring, directors_retiring)
  end

  it "renders a list of directors to retire" do
    render
    expect(rendered).to have_selector('ul.directors') do |ul|
      expect(ul).to contain("Sally Baker")
      expect(ul).to contain("John Smith")
    end
  end

  it "renders an 'electronic_nominations' field" do
    render
    expect(rendered).to have_selector("input[name='annual_general_meeting[electronic_nominations]']")
  end

  it "renders a date select for nominations_closing_date" do
    render
    expect(rendered).to have_selector("select[name='annual_general_meeting[nominations_closing_date(1i)]']", visible: false)
    expect(rendered).to have_selector("select[name='annual_general_meeting[nominations_closing_date(2i)]']", visible: false)
    expect(rendered).to have_selector("select[name='annual_general_meeting[nominations_closing_date(3i)]']", visible: false)
  end

  it "renders an 'electronic_voting' field" do
    render
    expect(rendered).to have_selector("input[name='annual_general_meeting[electronic_voting]']")
  end

  it "renders a date select for voting_closing_date" do
    render
    expect(rendered).to have_selector("select[name='annual_general_meeting[voting_closing_date(1i)]']", visible: false)
    expect(rendered).to have_selector("select[name='annual_general_meeting[voting_closing_date(2i)]']", visible: false)
    expect(rendered).to have_selector("select[name='annual_general_meeting[voting_closing_date(3i)]']", visible: false)
  end

end
