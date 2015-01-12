require 'spec_helper'

describe OrganisationsController do
  
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
  end
  
  describe "GET 'new'" do
    before(:each) do
      allow(Setting).to receive(:[]).with(:theme).and_return(nil)

      allow(Setting).to receive(:[]).with(:association_enabled).and_return('true')
      allow(Setting).to receive(:[]).with(:company_enabled).and_return('true')
      allow(Setting).to receive(:[]).with(:coop_enabled).and_return('true')
    end

    it "returns http success" do
      get 'new'
      expect(response).to be_success
    end

    context 'when only one organisation type is enabled' do
      before(:each) do
        allow(Setting).to receive(:[]).with(:company_enabled).and_return('false')
        allow(Setting).to receive(:[]).with(:coop_enabled).and_return('false')
      end

      it 'redirects to the new action for that organisation type' do
        get :new
        expect(response).to redirect_to(new_association_path)
      end
    end

  end

end
