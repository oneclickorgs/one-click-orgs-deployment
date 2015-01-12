require 'spec_helper'

describe 'ballots/new' do

  before(:each) do
    @election = mock_model(Election)
    assign(:election, @election)

    @ballot = mock_model(Ballot,
      :ranking_30 => nil,
      :ranking_31 => nil,
      :ranking_32 => nil
    ).as_new_record
    assign(:ballot, @ballot)

    @nominations = [
      mock_model(Nomination, :id => 30, :name => "John Smith"),
      mock_model(Nomination, :id => 31, :name => "Claire Simmons"),
      mock_model(Nomination, :id => 32, :name => "Belinda Marsh")
    ]
    assign(:nominations, @nominations)

    @annual_general_meeting = mock_model(AnnualGeneralMeeting, :happened_on => 2.weeks.from_now)
    assign(:annual_general_meeting, @annual_general_meeting)
  end

  it "renders a ranking field for each of the nominations" do
    render
    expect(rendered).to have_selector(:input, :name => 'ballot[ranking_30]')
    expect(rendered).to have_selector(:input, :name => 'ballot[ranking_31]')
    expect(rendered).to have_selector(:input, :name => 'ballot[ranking_32]')
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector(:input, :type => 'submit')
  end

end
