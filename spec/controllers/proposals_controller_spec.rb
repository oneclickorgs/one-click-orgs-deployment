require 'spec_helper'

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
        @organisation.stub(:resolution_proposals)
      end
      
      it "looks up and assigns the draft proposals" do
        @resolutions_association = mock("resolutions association",
          :currently_open => []
        )
        @organisation.stub(:resolutions).and_return(@resolutions_association)
        
        @draft_resolutions_association = mock("draft resolutions association")
        @resolutions_association.stub(:draft).and_return(@draft_resolutions_association)
        
        get :index
        
        assigns[:draft_proposals].should == @draft_resolutions_association
      end
      
      it "looks up and assigns the resolution proposals" do
        @resolution_proposals_association = mock("resolution proposals association")
        
        @organisation.should_receive(:resolution_proposals).and_return(@resolution_proposals_association)
        
        get :index
        
        assigns[:resolution_proposals].should == @resolution_proposals_association
      end
    end
  end
  
end
