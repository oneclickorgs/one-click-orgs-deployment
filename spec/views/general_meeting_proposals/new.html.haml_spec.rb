require 'rails_helper'

describe 'general_meeting_proposals/new' do

  let(:general_meeting_proposal) { mock_model(GeneralMeetingProposal) }

  before(:each) do
    assign(:general_meeting_proposal, general_meeting_proposal)
  end

  it 'renders a description field' do
    render
    expect(rendered).to have_selector(:textarea, name: 'general_meeting_proposal[description]')
  end

  it 'renders a submit button' do
    render
    expect(rendered).to have_selector(:input, type: 'submit')
  end

end
