require 'rails_helper'

describe ProposalsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET index" do
    before(:each) do
      @organisation.stub_chain(:proposals, :currently_open)
      @organisation.stub_chain(:decisions, :order, :limit)
      @organisation.stub_chain(:proposals, :failed, :limit)
    end

    context "when current organisation is a co-op" do
      before(:each) do
        @organisation.stub_chain(:resolutions, :draft)
        @organisation.stub_chain(:resolutions, :currently_open)
        @organisation.stub_chain(:resolutions, :draft)
        @organisation.stub_chain(:resolutions, :accepted).and_return([])
        @organisation.stub_chain(:resolutions, :rejected).and_return([])

        allow(@organisation).to receive(:resolution_proposals).and_return(
          @resolution_proposals_association = double("resolution proposals association",
            :currently_open => [],
            :where => []
          )
        )

        @organisation.stub_chain(:general_meetings, :upcoming).and_return([])
      end

      it "looks up and assigns the draft proposals" do
        @resolutions_association = double("resolutions association",
          :currently_open => [],
          :accepted => [],
          :rejected => []
        )
        allow(@organisation).to receive(:resolutions).and_return(@resolutions_association)

        @draft_resolutions_association = double("draft resolutions association")
        allow(@resolutions_association).to receive(:draft).and_return(@draft_resolutions_association)

        get :index

        expect(assigns[:draft_proposals]).to eq(@draft_resolutions_association)
      end

      it "looks up and assigns the resolution proposals" do
        @currently_open_resolution_proposals = double("currently-open resolution proposals")
        expect(@resolution_proposals_association).to receive(:currently_open).and_return(@currently_open_resolution_proposals)

        get :index

        expect(assigns[:resolution_proposals]).to eq(@currently_open_resolution_proposals)
      end
    end
  end

  describe "PUT open" do
    before(:each) do
      @resolutions_association = double("resolutions association")
      allow(@organisation).to receive(:resolutions).and_return(@resolutions_association)
      @resolution = mock_model(Resolution)
      allow(@resolutions_association).to receive(:find).and_return(@resolution)
      allow(@resolution).to receive(:start!)
    end

    def put_open
      put :open, :id => '1'
    end

    it "finds the resolution" do
      expect(@resolutions_association).to receive(:find).with('1').and_return(@resolution)
      put_open
    end

    it "opens the resolution" do
      expect(@resolution).to receive(:start!)
      put_open
    end

    it "redirects to the proposals page" do
      put_open
      expect(response).to redirect_to('/proposals')
    end

    it "checks authorisation"
  end

end
