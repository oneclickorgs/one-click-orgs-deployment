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
  
    describe "a successful POST" do
      before(:each) do
        post(members_path, :member => {:first_name => "Bob", :last_name => "Smith", :email => "bob@example.com"})
      end
      
      it "redirects to resource(:members)" do
        @response.should redirect_to(members_path)
      end
      
      it "should set a notice flash" do
        flash[:notice].should_not be_blank
      end
    end
    
    describe "an unsuccessful POST" do
      before(:each) do
        # Missing 'email' attribute
        post(members_path, :member => {:first_name => "Bob", :last_name => "Smith", :email => ""})
      end
      
      it "renders the new member form" do
        response.should render_template('members/new')
      end
      
      it "sets a helpful error flash" do
        flash[:error].should =~ /Email/
      end
      
      it "retains the contents of the new member form" do
        response.should have_selector('input', :name => 'member[first_name]', :value => 'Bob')
      end
    end
  end

  describe "/members/1" do 
    describe "a successful DELETE, given a member exists" do
      let(:eject_member_proposals_association) {mock('eject_member_proposals association', :new => proposal)}
      let(:proposal) {mock_model(EjectMemberProposal, :start => true, :accepted? => false)}

      before(:each) do
        @member = @organisation.members.make
        @organisation.stub(:eject_member_proposals).and_return(eject_member_proposals_association)
      end
      
      it "should create the proposal to eject the member" do
        eject_member_proposals_association.should_receive(:new).with(
          :parameters => {'id' => @member.id},
          :title => "Eject #{@member.name} from test",
          :description => 'Power grab!',
          :proposer_member_id => @user.id
        ).and_return(@proposal = mock('proposal'))
        @proposal.should_receive(:start).and_return(true)
        @proposal.should_receive(:accepted?).and_return(false)
        
        make_request
      end

      it "should redirect to the control center" do
        make_request
        @response.should redirect_to('/')
      end
      
      def make_request
        delete(member_path(@member), {:description => 'Power grab!'})
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
        @response.should have_selector("form[action='/members/#{@member.id}']") do |form|
          form.should have_selector "input[type=hidden][name=_method][value=delete]"
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
        it "raises an exception" do
          expect {
            put(member_path(@user), :member => {
              :first_name => "Bob",
              :last_name => "Smith",
              :email => "new@example.com",
              :active => '0'
            })
          }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
      end
    end
  end
end

