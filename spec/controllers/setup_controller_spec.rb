require 'spec_helper'

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

    it 'redirects to the organisation_types action' do
      post_create_domains
      expect(response).to redirect_to('/setup/organisation_types')
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
