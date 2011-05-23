require 'spec_helper'

describe "everything" do
  before(:each) do
    stub_constitution!
    stub_organisation!
    login
    set_permission!(default_user, :membership_proposal, true)
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
        @member = Member.make
        get '/members'
      end
    
      it "has a list of members" do
        @response.should have_selector("table.members tr")
      end
    end
  end

  describe "/members/1/edit, given a member exists" do
    before(:each) do
      @member = @organisation.members.make
    end
  
    it "responds successfully if resource == current_user" do
      get(edit_member_path(default_user))
      @response.should be_successful
    end

    it "responds unauthorized if resource != current_user" do
      get(edit_member_path(@member), {}, {'HTTP_REFERER' => 'http://www.example.com/'})
      response.should redirect_to '/'
    end  
  end



  describe "/members/1, given a member exists" do
    before(:each) do
      @member = @organisation.members.make
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
    end
  end
  
  describe "POST /members/create_founding_member" do
    before(:each) do
      stub_organisation!(false)
      set_permission!(default_user, :direct_edit, true)
      login
    end
    
    context "when valid member attributes are given" do
      before(:each) do
        post('/members/create_founding_member', :member => {:first_name => "Bob", :last_name => "Smith", :email => "bob@example.com"})
      end
      
      it "creates a new member" do
        @organisation.members.last.email.should == "bob@example.com"
      end
      
      it "redirect to members/index" do
        response.should redirect_to('/members')
      end
    end
    
    context "when invalid member attributes are given" do
      before(:each) do
        # Missing email
        post('/members/create_founding_member', :member => {:first_name => "Bob", :last_name => "Smith", :email => ""})
      end
      
      it "sets a helpful error flash" do
        flash[:error].should =~ /Email/
      end
      
      it "renders the new member page" do
        response.should render_template('members/new')
      end
      
      it "retains the contents of the new member form" do
        response.should have_selector('input', :name => 'member[first_name]', :value => 'Bob')
      end
    end
  end
end

