require 'rails_helper'

describe DocumentsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET index" do
    def get_index
      get :index
    end

    it "is successful" do
      get_index
      expect(response).to be_success
    end
  end

  describe "GET show" do
    before(:each) do
      allow(@organisation).to receive(:name)
    end

    def get_show
      get :show, :id => 'letter_of_engagement'
    end

    it "is successful" do
      get_show
      expect(response).to be_success
    end

    context "when id is 'money_laundering'" do
      def get_show
        get :show, :id => 'money_laundering'
      end

      it "renders the documents/money_laundering template" do
        get_show
        expect(response).to render_template('documents/money_laundering')
      end
    end
  end

end
