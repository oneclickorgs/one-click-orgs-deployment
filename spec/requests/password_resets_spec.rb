require 'spec_helper'

describe "PasswordResets" do
  before(:each) do
    default_association_constitution
    default_organisation
  end
  
  describe "resetting a password" do
    before(:each) do
      @member = @organisation.members.make
      @organisation.stub!(:members).and_return(@members_relation = mock('members_relation', :where => [@member]))
    end
    
    def post_create
      post('/password_resets', {:email => @member.email})
    end
    
    it "should generate a new password reset code for the member" do
      @member.should_receive(:new_password_reset_code!)
      @member.stub!(:password_reset_code).and_return('abcdefghij')
      post_create
    end
    
    it "should set the 'email' instance variable" do
      post_create
      assigns[:email].should == @member.email
    end
    
    it "should display the confirmation page" do
      post_create
      @response.should render_template('password_resets/show')
    end
    
    describe "when the member cannot be found" do
      before(:each) do
        @members_relation.stub!(:where).and_return([])
      end
      
      it "should set the 'email' instance variable" do
        post_create
        assigns[:email].should == @member.email
      end
      
      it "should still display the confirmation page" do
        post_create
        @response.should render_template('password_resets/show')
      end
    end
  end
end
