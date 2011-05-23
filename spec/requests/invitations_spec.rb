require 'spec_helper'

describe "invitations" do
  before(:each) do
    stub_organisation!(false)
    @member = @organisation.members.make(:active => false, :inducted_at => nil, :password => nil, :password_confirmation => nil)
  end
  
  describe "GET edit" do
    def get_edit
      get "/i/#{@member.invitation_code}"
    end
    
    it "is successful" do
      get_edit
      response.should be_successful
    end
    
    it "renders a form to update the invitation" do
      get_edit
      response.should have_selector :form, :action => "/invitations/#{@member.invitation_code}" do |form|
        form.should have_selector :input, :name => '_method', :value => 'put'
      end
    end
    
    it "shows fields to choose a password" do
      get_edit
      response.should have_selector(:input, :name => 'invitation[password]')
      response.should have_selector(:input, :name => 'invitation[password_confirmation]')
    end
    
    describe "rendering a hidden terms and conditions field" do
      it "renders a hidden terms and conditions field" do
        get_edit
        response.should have_selector(:input, :name => 'invitation[terms_and_conditions]', :type => 'hidden')
      end
      
      it "sets the value to '0'" do
        get_edit
        response.should have_selector(:input, :name => 'invitation[terms_and_conditions]', :value => '0')
      end
    end
  end
  
  describe "PUT update" do
    def post_update
      put "/invitations/#{@member.invitation_code}", 'invitation' => {'password' => 'letmein', 'password_confirmation' => 'letmein', 'terms_and_conditions' => '1'}
    end
    
    it "saves the member's new password" do
      post_update
      @member.reload
      @member.crypted_password.should be_present
      @member.salt should be_present
    end
    
    it "clears the member's invitation code" do
      post_update
      @member.reload
      @member.invitation_code.should be_blank
    end
    
    it "logs in the user" do
      post_update
      session[:user].should == @member.id
    end
    
    it "updates the user's last-logged-in-at timestamp" do
      post_update
      @member.reload
      @member.last_logged_in_at.should be_present
    end
    
    it "redirects to the home page" do
      post_update
      response.should redirect_to root_path
    end
  end
  
end
