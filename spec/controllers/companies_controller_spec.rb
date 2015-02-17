require 'rails_helper'

describe CompaniesController do
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
  end
  
  describe "GET new" do
    before(:each) do
      @member = mock_model(Member)
      allow(Member).to receive(:new).and_return(@member)
      
      @company = mock_model(Company)
      allow(Company).to receive(:new).and_return(@company)
    end
    
    it "builds a new member" do
      expect(Member).to receive(:new).and_return(@member)
      get :new
    end
    
    it "assigns the new member" do
      get :new
      expect(assigns(:member)).to eq(@member)
    end
    
    it "builds a new company" do
      expect(Company).to receive(:new).and_return(@company)
      get :new
    end
    
    it "assigns the new company" do
      get :new
      expect(assigns(:company)).to eq(@company)
    end
    
    it "is successful" do
      get :new
      expect(response).to be_successful
    end
    
    it "renders the company/new template" do
      get :new
      expect(response).to render_template('companies/new')
    end
  end
  
  describe "POST create" do
    before(:each) do
      @company = mock_model(Company, :save! => true, :host => "coffee.oneclickorgs.com")
      allow(Company).to receive(:new).and_return(@company)
      
      @members_association = double("member association")
      allow(@company).to receive(:members).and_return(@members_association)
      
      @member = mock_model(Member, :save! => true, :member_class= => nil, :state= => nil, :update_attribute => true)
      allow(@members_association).to receive(:build).and_return(@member)
      
      @director_member_class = mock_model(MemberClass, :description => "Director")
      @member_classes_association = double("member classes association")
      allow(@company).to receive(:member_classes).and_return(@member_classes_association)
      allow(@member_classes_association).to receive(:find_by_name).with('Director').and_return(@director_member_class)
      
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
      expect(Company).to receive(:new).with(@company_attributes).and_return(@company)
      post_create
    end
    
    it "saves the new company" do
      expect(@company).to receive(:save!).and_return(true)
      post_create
    end
    
    it "builds the new member" do
      expect(@members_association).to receive(:build).with(@member_attributes).and_return(@member)
      post_create
    end
    
    it "gives the new member a member class of Director" do
      expect(@member).to receive(:member_class=).with(@director_member_class)
      post_create
    end
    
    it "finds the member class only after saving the organisation" do
      expect(@company).to receive(:save!).ordered.and_return(true)
      expect(@company).to receive(:member_classes).ordered.and_return(@member_classes_association)
      
      post_create
    end
    
    it "makes the new member active" do
      expect(@member).to receive(:state=).with('active')
      post_create
    end
    
    it "saves the new member" do
      expect(@member).to receive(:save!).and_return(true)
      post_create
    end
    
    it "logs in the new member" do
      expect(controller).to receive(:log_in).with(@member)
      post_create
    end
    
    it "redirects to the dashboard for the new company" do
      post_create
      expect(response).to redirect_to('http://coffee.oneclickorgs.com/')
    end
    
    describe "when company attributes are not valid" do
      before(:each) do
        allow(@company).to receive(:valid?).and_return(false)
      end
      
      it "does not save the new member" do
        expect(@member).not_to receive(:save!)
        post_create
      end
      
      it "renders the new template" do
        post_create
        expect(response).to render_template 'companies/new'
      end
    end
    
    describe "when member attributes are not valid" do
      before(:each) do
        allow(@member).to receive(:valid?).and_return(false)
      end
      
      it "does not save the company" do
        expect(@company).not_to receive(:save!)
        post_create
      end
      
      it "renders the new template" do
        post_create
        expect(response).to render_template 'companies/new'
      end
    end
  end
  
end
