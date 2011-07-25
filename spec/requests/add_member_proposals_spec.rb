require 'spec_helper'

describe "add-member proposals" do
  before(:each) do
    default_association_constitution
    default_association
    association_login
    set_permission!(default_association_user, :membership_proposal, true)
  end
  
  describe "POST create" do
    before(:each) do
      post('/add_member_proposals', :add_member_proposal => {:first_name => "Bob", :last_name => "Smith", :email => "bob@example.com"})
    end
    
    it "redirects to root" do
      @response.should redirect_to(root_path)
    end
    
    it "should set a notice flash" do
      flash[:notice].should_not be_blank
    end
    
    context "when validation fails" do
      before(:each) do
        # Missing 'email' attribute
        post('/add_member_proposals', :add_member_proposal => {:first_name => "Bob", :last_name => "Smith", :email => ""})
      end
      
      it "renders the new add-member proposal form" do
        response.should render_template('add_member_proposals/new')
      end
      
      it "sets an error flash" do
        flash[:error].should be_present
      end
      
      it "displays the errors" do
        response.should have_selector('ul.errors li', :content => "Email can't be blank")
      end
      
      it "retains the contents of the new member form" do
        response.should have_selector('input', :name => 'add_member_proposal[first_name]', :value => 'Bob')
      end
    end
  end
end
