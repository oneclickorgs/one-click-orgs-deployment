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
      let(:constitution) {double("constitution")}
      let(:cpb) {mock_model(ConstitutionProposalBundle)}

      before(:each) do
        controller.stub(:can?).and_return(false)
        @organisation.stub(:build_constitution_proposal_bundle).and_return(cpb)
      end

      def get_edit
        get :edit
      end

      context "when current user can create resolutions" do
        before(:each) do
          controller.stub(:can?).with(:create, Resolution).and_return(true)
        end

        it "allows editing" do
          @organisation.stub(:constitution).and_return(constitution)

          get_edit
          assigns[:allow_editing].should be_true
        end
      end

      context "when current user can create resolution proposals" do
        before(:each) do
          controller.stub(:can?).with(:create, ResolutionProposal).and_return(true)

          @organisation.stub(:constitution).and_return(constitution)
        end

        it "allows editing" do
          get_edit
          assigns[:allow_editing].should be_true
        end

        it "builds a constitution_proposal_bundle" do
          @organisation.should_receive(:build_constitution_proposal_bundle).and_return(cpb)
          get_edit
        end

        it "assigns the constitution proposal bundle" do
          get_edit
          assigns[:constitution_proposal_bundle].should == cpb
        end
      end
    end
  end
end
