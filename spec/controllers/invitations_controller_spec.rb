require 'spec_helper'

describe InvitationsController do
  
  let(:organisation) { mock_model(Organisation,
    :name => "The Yacht Club"
  ) }
  
  before(:each) do
    controller.class.skip_before_filter :prepare_notifications
    
    allow(controller).to receive(:ensure_set_up).and_return(true)
    allow(controller).to receive(:ensure_organisation_exists).and_return(true)
    allow(controller).to receive(:ensure_member_inducted).and_return(true)
    
    allow(controller).to receive(:co).and_return(organisation)
  end
  
  describe "GET edit" do
    context "when given an invalid invitation code" do
      before(:each) do
        allow(Member).to receive(:find_by_invitation_code).and_return(nil)
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
        allow(Invitation).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end
      
      it "should render a 404" do
        post :update, :id => 'invalid'
        expect(response.code).to eq('404')
      end
    end
  end
end
