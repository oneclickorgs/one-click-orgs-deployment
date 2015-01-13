require 'rails_helper'

describe SetupController do

  describe 'GET index' do
    it 'redirects to the domains action' do
      get :index
      expect(response).to redirect_to('/setup/domains')
    end
  end

  describe 'GET domains' do
    it 'is successful' do
      get :domains
      expect(response).to be_successful
    end
  end

  describe "POST create_domains" do
    def post_create_domains
      post :create_domains, base_domain: 'example.com', signup_domain: 'create.example.com'
    end

    it 'redirects to the administrator action' do
      post_create_domains
      expect(response).to redirect_to('/setup/administrator')
    end
  end

  describe 'GET administrator' do
    let(:administrator) {mock_model(Administrator)}

    before(:each) do
      allow(Administrator).to receive(:new).and_return(administrator)
    end

    def get_administrator
      get :administrator
    end

    it 'assigns the new administrator' do
      get_administrator
      expect(assigns[:administrator]).to eq(administrator)
    end

    it 'is successful' do
      get_administrator
      expect(response).to be_successful
    end
  end

  describe 'POST create_administrator' do
    let(:administrator_attributes) {{}}
    let(:administrator) {mock_model(Administrator, save: true)}

    before(:each) do
      allow(Administrator).to receive(:new).and_return(administrator)
    end

    def post_create_administrator
      post :create_administrator, administrator: administrator_attributes
    end

    it 'creates the administrator' do
      expect(Administrator).to receive(:new).with(administrator_attributes).and_return(administrator)
      expect(administrator).to receive(:save).and_return(false)
      post_create_administrator
    end

    it 'redirects to the organisation types setup action' do
      post_create_administrator
      expect(response).to redirect_to('/setup/organisation_types')
    end

    context 'when creating the Administrator fails' do
      before(:each) do
        allow(administrator).to receive(:save).and_return(false)
      end

      it 'sets an error flash' do
        post_create_administrator
        expect(flash[:error]).to be_present
      end

      it 'renders the administrator action' do
        post_create_administrator
        expect(response).to render_template('setup/administrator')
      end
    end
  end

  describe "POST set_organisation_types" do
    before(:each) do
      Setting[:signup_domain] = 'create.example.com'
    end

    def post_set_organisation_types
      post :set_organisation_types, association: '1', company: '1'
    end

    it 'saves the chosen organisation types' do
      expect(Setting).to receive(:[]=).with(:association_enabled, 'true')
      expect(Setting).to receive(:[]=).with(:company_enabled, 'true')
      expect(Setting).to receive(:[]=).with(:coop_enabled, 'false')
      post_set_organisation_types
    end

    it 'redirects' do
      post_set_organisation_types
      expect(response).to be_redirect
    end
  end

end
