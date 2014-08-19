require 'spec_helper'

describe 'general_meeting_proposals/show' do

  let(:general_meeting_proposal) {mock_model(GeneralMeetingProposal,
    description: 'Discuss the inactivity of the board.',
    proposer: proposer,
    id: 1,
    vote_by: nil,
    voters_for: [mock_model(Member, name: 'David Supporter')],
    open?: true
  )}
  let(:proposer) { mock_model(Member, name: 'Glenda Proposer') }

  before(:each) do
    assign(:general_meeting_proposal, general_meeting_proposal)
    allow(view).to receive(:current_user).and_return(mock_model(Member))
    allow(view).to receive(:co).and_return(mock_model(Coop, members_required_to_force_resolution: 10))
  end

  it 'renders the description' do
    render
    expect(rendered).to have_content('Discuss the inactivity of the board.')
  end

  it 'renders the name of the proposer' do
    render
    expect(rendered).to have_content('Glenda Proposer')
  end

  it 'renders the names of the people who have voted for the proposal' do
    render
    expect(rendered).to have_content('David Supporter')
  end

  context 'when the user is the proposer' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(proposer)
    end

    it 'renders a link to the general meeting proposal' do
      render
      expect(rendered).to have_selector(:a, href: general_meeting_proposal_url(general_meeting_proposal))
    end
  end

  context 'when user has not voted for the proposal' do
    before(:each) do
      allow(general_meeting_proposal).to receive(:vote_by).and_return(false)
    end

    it 'renders a button to vote for the proposal' do
      render
      expect(rendered).to have_selector("form[action^='/votes/vote_for/1']") do |form|
        expect(form).to have_selector(:input, type: 'submit')
      end
    end
  end

  context 'when user has already voted for the proposal' do
    before(:each) do
      allow(general_meeting_proposal).to receive(:vote_by).and_return(true)
    end

    it 'renders a message saying that the user has already voted for the proposal' do
      render
      expect(rendered).to have_content('You have already supported this application.')
    end

    it 'does not render a button to vote for the proposal' do
      render
      expect(rendered).to_not have_selector("form[action^='/votes/vote_for/1']")
    end
  end

end
