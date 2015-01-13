require 'rails_helper'

include ControllerSpecHelper

describe TerminateDirectorshipResolutionsController do

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe 'GET new' do
    let(:directors) {[
      mock_model(Director, name: 'Ann', id: 1),
      mock_model(Director, name: 'Bob', id: 2)
    ]}

    let(:terminate_directorship_resolutions_association) {double('terminate_directorship_resolutions association', build: nil)}

    before(:each) do
      allow(@organisation).to receive(:directors).and_return(directors)
      allow(@organisation).to receive(:terminate_directorship_resolutions).and_return(terminate_directorship_resolutions_association)
    end

    def get_new
      get :new
    end

    it 'assigns a list of current directors for use in a select element' do
      get_new
      expect(assigns(:directors_for_select)).to eq([
        ['Ann', 1],
        ['Bob', 2]
      ])
    end
  end

end
