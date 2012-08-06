require 'spec_helper'

describe ConstitutionProposalBundlesController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  context "when current organisation is a Coop" do
    before(:each) do
      stub_coop
      stub_login
    end

    describe "POST create" do
      let(:constitution_proposal_bundle) {mock_model(ConstitutionProposalBundle,
        :proposer= => nil,
        :save => true
      )}

      before(:each) do
        controller.stub(:authorize!).with(:create, ConstitutionProposalBundle).and_return(true)
        @organisation.stub(:build_constitution_proposal_bundle).and_return(constitution_proposal_bundle)
      end

      def post_create
        post :create
      end

      it "redirects to the proposals index" do
        post_create
        response.should redirect_to('/proposals')
      end
    end
  end

end
