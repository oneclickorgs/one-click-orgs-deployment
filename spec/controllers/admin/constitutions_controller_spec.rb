require 'spec_helper'

describe Admin::ConstitutionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_administrator_login
  end

  describe "GET show" do
    let(:organisation) {mock_model(Organisation, :constitution => constitution)}
    let(:constitution) {double("constiution")}

    before(:each) do
      Organisation.stub(:find).and_return(organisation)
    end

    context "when format is PDF" do
      def get_show
        get :show, :id => 111, :format => :pdf
      end

      it "calls generate_pdf" do
        controller.should_receive(:generate_pdf)
        get_show
      end
    end
  end

end
