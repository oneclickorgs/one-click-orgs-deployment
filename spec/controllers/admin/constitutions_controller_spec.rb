require 'rails_helper'

describe Admin::ConstitutionsController do

  include ControllerSpecHelper

  let(:organisation) {mock_model(Organisation, :constitution => constitution)}
  let(:constitution) {double("constitution")}

  before(:each) do
    stub_app_setup
    stub_administrator_login

    allow(Organisation).to receive(:find).and_return(organisation)
  end

  describe "GET show" do
    context "when format is PDF" do
      def get_show
        get :show, :id => 111, :format => :pdf
      end

      it "calls generate_pdf" do
        expect(controller).to receive(:generate_pdf)
        get_show
      end
    end
  end

  describe "GET edit" do
    def get_edit
      get :edit, :id => '111'
    end

    it "is successful" do
      get_edit
      expect(response).to be_success
    end
  end

end
