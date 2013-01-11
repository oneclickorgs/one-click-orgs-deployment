require 'spec_helper'

require 'active_model/mass_assignment_security/sanitizer'

describe "members" do
  
  before(:each) do
    default_association_constitution
    default_organisation
    association_login
    set_permission!(default_association_user, :membership_proposal, true)
  end
  
  describe "/members" do
    describe "GET" do
      before(:each) do
        get(members_path)
      end
    
      it "responds successfully" do
        @response.should be_successful
      end

      it "contains a list of members" do
        @response.should have_selector("table.members")
      end
    end
  
    describe "GET, given a members exists" do
      before(:each) do
        @member = Member.make!
        get '/members'
      end
    
      it "has a list of members" do
        @response.should have_selector("table.members tr")
      end
    end
  end

  describe "/members/1/edit, given a member exists" do
    before(:each) do
      @member = @organisation.members.make!
    end
  
    it "responds successfully if resource == current_user" do
      get(edit_member_path(default_association_user))
      @response.should be_successful
    end

    it "responds unauthorized if resource != current_user" do
      get(edit_member_path(@member), {}, {'HTTP_REFERER' => 'http://www.example.com/'})
      response.should redirect_to '/'
    end  
  end



  describe "/members/1, given a member exists" do
    before(:each) do
      @member = @organisation.members.make!
      set_permission!(@user, :membership_proposal, true)
    end
    
    describe "GET" do
      before(:each) do
        get(member_path(@member))
      end
      
      it "responds successfully" do
        @response.should be_successful
      end
      
      it "should display a form to eject the member" do
        @response.should have_selector("form[action='/eject_member_proposals']") do |form|
          form.should have_selector "input[name='eject_member_proposal[member_id]'][value='#{@member.id}']"
        end
      end
    end
  
    describe "PUT" do
      before(:each) do
        put(member_path(@member), :member => {:id => @member.id})
      end
  
      it "redirect to the member show action" do
        @response.should redirect_to(member_path(@member))
      end
      
      context "when attempting to update restricted attributes" do
        def put_update
          put(member_path(@user), :member => {
            :first_name => "Bob",
            :last_name => "Smith",
            :email => "new@example.com",
            :active => '0'
          })
        end

        it "raises an ActiveModel::MassAssignmentSecurity:Error exception" do
          expect {put_update}.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
      end
    end
  end
end

