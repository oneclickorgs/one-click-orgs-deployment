require 'rails_helper'

describe Admin::DocumentsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_administrator_login
    stub_generate_pdf
  end

  describe "GET show" do
    let(:coop) {mock_model(Coop, :name => "Acme Ltd")}

    before(:each) do
      allow(Coop).to receive(:find).and_return(coop)
    end

    context "when the id is 'money_laundering' and the format is 'pdf'" do
      def get_show
        get :show, :coop_id => 111, :id => 'money_laundering', :format => 'pdf'
      end

      it "renders the 'documents/money_laundering' template" do
        get_show
        expect(response).to render_template('documents/money_laundering')
      end

      it "renders a PDF" do
        expect_controller_to_generate_pdf
        get_show
      end
    end
  end

end
