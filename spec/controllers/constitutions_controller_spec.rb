require 'spec_helper'

describe ConstitutionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  context "when current organisation is a co-op" do
    before(:each) do
      stub_coop
      stub_login
    end

    describe "GET edit" do
      def get_edit
        get :edit
      end

      context "when current user can create resolutions" do
        let(:constitution) {mock("constitution")}

        before(:each) do
          controller.stub(:can?).and_return(false)
          controller.stub(:can?).with(:create, Resolution).and_return(true)

          @organisation.stub(:build_constitution_proposal_bundle)
        end

        it "allows editing" do
          @organisation.stub(:constitution).and_return(constitution)

          get_edit
          assigns[:allow_editing].should be_true
        end
      end
    end
  end
end
