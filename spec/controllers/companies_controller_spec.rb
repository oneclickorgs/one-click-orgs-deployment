require 'spec_helper'

describe CompaniesController do
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
  end
  
  describe "GET new" do
    before(:each) do
      @member = mock_model(Member)
      Member.stub!(:new).and_return(@member)
      
      @company = mock_model(Company)
      Company.stub!(:new).and_return(@company)
    end
    
    it "builds a new member" do
      Member.should_receive(:new).and_return(@member)
      get :new
    end
    
    it "assigns the new member" do
      get :new
      assigns(:member).should == @member
    end
    
    it "builds a new company" do
      Company.should_receive(:new).and_return(@company)
      get :new
    end
    
    it "assigns the new company" do
      get :new
      assigns(:company).should == @company
    end
    
    it "is successful" do
      get :new
      response.should be_successful
    end
    
    it "renders the company/new template" do
      get :new
      response.should render_template('companies/new')
    end
  end
  
  describe "POST create" do
    before(:each) do
      @company = mock_model(Company, :save => true, :host => "coffee.oneclickorgs.com")
      Company.stub!(:new).and_return(@company)
      
      @members_association = mock("member association")
      @company.stub!(:members).and_return(@members_association)
      
      @member = mock_model(Member, :save => true, :member_class= => nil, :update_attribute => true)
      @members_association.stub!(:build).and_return(@member)
      
      @director_member_class = mock_model(MemberClass, :description => "Director")
      @member_classes_association = mock("member classes association")
      @company.stub!(:member_classes).and_return(@member_classes_association)
      @member_classes_association.stub!(:find_by_name).with('Director').and_return(@director_member_class)
      
      @member_attributes = {
        'first_name' => "Bob",
        'last_name' => "Smith",
        'email' => "bob@example.com",
        'password' => "letmein",
        'password_confirmation' => "letmein"
      }
      @company_attributes = {
        'name' => "Coffee Ventures Ltd",
        'subdomain' => "coffee"
      }
    end
    
    def post_create
      post :create, 'member' => @member_attributes, 'company' => @company_attributes
    end
    
    it "builds the new company" do
      Company.should_receive(:new).with(@company_attributes).and_return(@company)
      post_create
    end
    
    it "saves the new company" do
      @company.should_receive(:save).and_return(true)
      post_create
    end
    
    it "builds the new member" do
      @members_association.should_receive(:build).with(@member_attributes).and_return(@member)
      post_create
    end
    
    it "gives the new member a member class of Director" do
      @member.should_receive(:member_class=).with(@director_member_class)
      post_create
    end
    
    it "makes the new member active" do
      @member.should_receive(:state=).with('active')
      post_create
    end
    
    it "saves the new member" do
      @member.should_receive(:save).and_return(true)
      post_create
    end
    
    it "logs in the new member" do
      controller.should_receive(:log_in).with(@member)
      post_create
    end
    
    it "redirects to the dashboard for the new company" do
      post_create
      response.should redirect_to('http://coffee.oneclickorgs.com/')
    end
    
    describe "when company attributes are not valid" do
      it "handles the error gracefully"
    end
    
    describe "when member attributes are not valid" do
      it "handles the error gracefully"
    end
  end
  
end
