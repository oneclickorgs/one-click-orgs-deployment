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
    
    context "when current organisaion is a co-op" do
      it "looks up and assigns the draft proposals" do
        @resolutions_association = mock("resolutions association")
        @organisation.stub(:resolutions).and_return(@resolutions_association)
        
        @draft_resolutions_association = mock("draft resolutions association")
        @resolutions_association.stub(:draft).and_return(@draft_resolutions_association)
        
        get :index
        
        assigns[:draft_proposals].should == @draft_resolutions_association
      end
    end
  end
  
end
