require 'rails_helper'

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
      let(:constitution) {double("constitution")}
      let(:cpb) {mock_model(ConstitutionProposalBundle)}

      before(:each) do
        allow(controller).to receive(:can?).and_return(false)
        allow(@organisation).to receive(:build_constitution_proposal_bundle).and_return(cpb)
      end

      def get_edit
        get :edit
      end

      context "when current user can create resolutions" do
        before(:each) do
          allow(controller).to receive(:can?).with(:create, Resolution).and_return(true)
        end

        it "allows editing" do
          allow(@organisation).to receive(:constitution).and_return(constitution)

          get_edit
          expect(assigns[:allow_editing]).to be true
        end
      end

      context "when current user can create resolution proposals" do
        before(:each) do
          allow(controller).to receive(:can?).with(:create, ResolutionProposal).and_return(true)

          allow(@organisation).to receive(:constitution).and_return(constitution)
        end

        it "allows editing" do
          get_edit
          expect(assigns[:allow_editing]).to be true
        end

        it "builds a constitution_proposal_bundle" do
          expect(@organisation).to receive(:build_constitution_proposal_bundle).and_return(cpb)
          get_edit
        end

        it "assigns the constitution proposal bundle" do
          get_edit
          expect(assigns[:constitution_proposal_bundle]).to eq(cpb)
        end
      end
    end
  end
end
