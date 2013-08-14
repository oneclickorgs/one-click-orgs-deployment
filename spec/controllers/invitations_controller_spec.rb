require 'spec_helper'

describe InvitationsController do
  
  let(:organisation) { mock_model(Organisation,
    :name => "The Yacht Club"
  ) }
  
  before(:each) do
    controller.class.skip_before_filter :prepare_notifications
    
    controller.stub(:ensure_set_up).and_return(true)
    controller.stub(:ensure_organisation_exists).and_return(true)
    controller.stub(:ensure_member_inducted).and_return(true)
    
    controller.stub(:co).and_return(organisation)
  end
  
  describe "GET edit" do
    context "when given an invalid invitation code" do
      before(:each) do
        Member.stub(:find_by_invitation_code).and_return(nil)
      end
    
      it "should raise a NotFound exception" do
        # lambda { get :edit, :id => 'invalid' }.should raise_error(NotFound)
        get :edit, :id => 'invalid'
      end
    end
  end
  
  describe "POST update" do
    context "when given an invalid invitation code" do
      before(:each) do
        Invitation.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      end
      
      it "should render a 404" do
        post :update, :id => 'invalid'
        response.code.should == '404'
      end
    end
  end
end
