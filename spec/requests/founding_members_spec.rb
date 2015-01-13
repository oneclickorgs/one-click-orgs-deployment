require 'rails_helper'

describe "founding members" do

  include RequestSpecHelper
  
  before(:each) do
    default_association(:state => 'pending')
    set_permission!(default_association_user, :founder, true)
    set_permission!(default_association_user, :membership_proposal, true)
    association_login
    @user.member_class = @organisation.member_classes.find_by_name("Founder")
    @user.save!
  end
  
  describe "POST /founding_member" do
    context "when valid member attributes are given" do
      before(:each) do
        post('/founding_members', :founding_member => {:first_name => "Bob", :last_name => "Smith", :email => "bob@example.com"})
      end
      
      it "creates a new member" do
        expect(@organisation.members.last.email).to eq("bob@example.com")
      end
      
      it "sets the correct member class" do
        expect(@organisation.members.last.member_class.name).to eq("Founding Member")
      end
      
      it "redirect to members/index" do
        expect(response).to redirect_to('/members')
      end
    end
    
    context "when invalid member attributes are given" do
      before(:each) do
        # Missing email
        post('/founding_members', :founding_member => {:first_name => "Bob", :last_name => "Smith", :email => ""})
      end
      
      it "sets an error flash" do
        expect(flash[:error]).to be_present
      end
      
      it "displays the errors" do
        expect(page).to have_selector('ul.errors li', :text => "Email can't be blank")
      end
      
      it "renders the new member page" do
        expect(response).to render_template('founding_members/new')
      end
      
      it "retains the contents of the new member form" do
        expect(page).to have_selector("input[name='founding_member[first_name]'][value='Bob']")
      end
    end
  end
  
end
