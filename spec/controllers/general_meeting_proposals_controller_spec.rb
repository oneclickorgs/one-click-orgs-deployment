require 'rails_helper'

describe GeneralMeetingProposalsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe 'GET show' do
    let(:general_meeting_proposals) {double('general_meeting_proposals association on Coop',
      find: general_meeting_proposal
    )}
    let(:general_meeting_proposal) {mock_model(GeneralMeetingProposal)}

    before(:each) do
      allow(@organisation).to receive(:general_meeting_proposals).and_return(general_meeting_proposals)
    end

    def get_show
      get :show, id: '1'
    end

    it 'finds the GeneralMeetingProposal' do
      expect(general_meeting_proposals).to receive(:find).with('1').and_return(general_meeting_proposal)
      get_show
    end

    it 'assigns the GeneralMeetingProposal' do
      get_show
      expect(assigns[:general_meeting_proposal]).to eq(general_meeting_proposal)
    end

    it 'is successful' do
      get_show
      expect(response).to be_success
    end
  end

  describe 'GET new' do
    let(:general_meeting_proposals_association) { double('general_meeting_proposals association on Coop',
      build: general_meeting_proposal
    ) }
    let(:general_meeting_proposal) { mock_model(GeneralMeetingProposal) }

    before(:each) do
      allow(@organisation).to receive(:general_meeting_proposals).and_return(general_meeting_proposals_association)
    end

    def get_new
      get :new
    end

    it 'is successful' do
      get_new
      expect(response).to be_success
    end

    it 'builds a new GeneralMeetingProposal' do
      expect(general_meeting_proposals_association).to receive(:build).and_return(general_meeting_proposal)
      get_new
    end

    it 'assigns the GeneralMeetingProposal' do
      get_new
      expect(assigns[:general_meeting_proposal]).to eq(general_meeting_proposal)
    end
  end

  describe 'POST create' do
    let(:general_meeting_proposals_association) { double('general_meeting_proposals association on Coop',
      build: general_meeting_proposal
    ) }
    let(:general_meeting_proposal) { mock_model(GeneralMeetingProposal,
      :save! => nil,
      :proposer= => nil
    ) }
    let(:general_meeting_proposal_parameters) { {'description' => 'Lorem ipsum.'} }

    before(:each) do
      allow(@organisation).to receive(:general_meeting_proposals).and_return(general_meeting_proposals_association)
    end

    def post_create
      post :create, general_meeting_proposal: general_meeting_proposal_parameters
    end

    it 'builds a new general meeting proposal using the parameters' do
      expect(general_meeting_proposals_association).to receive(:build).with(general_meeting_proposal_parameters).and_return(general_meeting_proposal)
      post_create
    end

    it 'sets the proposer' do
      expect(general_meeting_proposal).to receive(:proposer=).with(@user)
      post_create
    end

    it 'redirects' do
      post_create
      expect(response).to be_redirect
    end
  end

end
