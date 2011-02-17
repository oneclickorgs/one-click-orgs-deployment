require 'spec_helper'

describe ApplicationController do
  describe "notifications" do
    before(:each) do
      @user = mock_model(Member,
        :member_class => mock_model(MemberClass, :name => 'Member')
      )
      controller.stub!(:current_user).and_return(@user)
      
      @organisation = mock_model(Organisation,
        :pending? => false,
        :proposed? => false,
        :active? => true
      )
      controller.stub!(:co).and_return(@organisation)
      
      @fop = mock_model(FoundOrganisationProposal,
        :creation_date => 2.days.ago.utc
      )
      @organisation.stub!(:found_organisation_proposals).and_return(
        @found_organisation_proposals_association = mock('found organisation proposals association', :last => @fop)
      )
    end
    
    describe "founding_proposal_passed notification" do
      it "appears when the organisation is active and the user was a founding member" do
        @user.stub!(:created_at).and_return(3.days.ago.utc)
        
        controller.should_receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
      
      it "does not appear when the organisation is active and the user is a normal member" do
        @user.stub!(:created_at).and_return(1.day.ago.utc)
        
        controller.should_not_receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
      
      it "does not appear when the organisation is pending" do
        @organisation.stub!(:pending?).and_return(true)
        @organisation.stub!(:proposed?).and_return(false)
        @organisation.stub!(:active?).and_return(false)
        
        @found_organisation_proposals_association.stub!(:last).and_return(nil)
        
        controller.should_not_receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
      
      it "does not appear when the organisation is proposed" do
        @organisation.stub!(:pending?).and_return(false)
        @organisation.stub!(:proposed?).and_return(true)
        @organisation.stub!(:active?).and_return(false)
        
        controller.should_not_receive(:show_notification_once).with(:founding_proposal_passed)
        controller.prepare_notifications
      end
    end
  end
end
