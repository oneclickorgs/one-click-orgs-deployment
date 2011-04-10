require 'spec_helper'
require 'lib/not_found'

describe InvitationsController do
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
