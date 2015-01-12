require 'spec_helper'

describe ApplicationController do
  describe "notifications" do
    before(:each) do
      @user = mock_model(Member,
        :member_class => mock_model(MemberClass, :name => 'Member')
      )
      allow(controller).to receive(:current_user).and_return(@user)
      
      @organisation = mock_model(Association,
        :pending? => false,
        :proposed? => false,
        :active? => true
      )
      allow(controller).to receive(:co).and_return(@organisation)
      
      @fap = mock_model(FoundAssociationProposal,
        :creation_date => 2.days.ago.utc
      )
      allow(@organisation).to receive(:found_association_proposals).and_return(
        @found_association_proposals_association = double('found association proposals association', :last => @fap)
      )
    end
    
    describe "founding_proposal_passed notification" do
      it "appears when the organisation is active and the user was a founding member" do
        allow(@user).to receive(:created_at).and_return(3.days.ago.utc)
        
        expect(controller).to receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
      
      it "does not appear when the organisation is active and the user is a normal member" do
        allow(@user).to receive(:created_at).and_return(1.day.ago.utc)
        
        expect(controller).not_to receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
      
      it "does not appear when the organisation is pending" do
        allow(@organisation).to receive(:pending?).and_return(true)
        allow(@organisation).to receive(:proposed?).and_return(false)
        allow(@organisation).to receive(:active?).and_return(false)
        
        allow(@found_association_proposals_association).to receive(:last).and_return(nil)
        
        expect(controller).not_to receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
      
      it "does not appear when the organisation is proposed" do
        allow(@organisation).to receive(:pending?).and_return(false)
        allow(@organisation).to receive(:proposed?).and_return(true)
        allow(@organisation).to receive(:active?).and_return(false)
        
        expect(controller).not_to receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
    end
  end
end
