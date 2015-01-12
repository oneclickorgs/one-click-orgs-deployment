require 'rails_helper'

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
        allow(controller).to receive(:authorize!).with(:create, ConstitutionProposalBundle).and_return(true)
        allow(@organisation).to receive(:build_constitution_proposal_bundle).and_return(constitution_proposal_bundle)
        allow(controller).to receive(:can?).with(:create, Resolution).and_return(true)
      end

      def post_create
        post :create
      end

      it "redirects to the proposals index" do
        post_create
        expect(response).to redirect_to('/proposals')
      end
    end
  end

end
