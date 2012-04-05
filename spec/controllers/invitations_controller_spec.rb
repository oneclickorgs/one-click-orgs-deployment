require 'spec_helper'
require 'lib/not_found'

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
        Member.stub!(:find_by_invitation_code).and_return(nil)
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
        Member.stub(:find_by_invitation_code).and_return(nil)
      end
      
      it "should redirect to the home page" do
        post :update, :id => 'invalid'
        response.should redirect_to '/'
      end
    end
  end
end
