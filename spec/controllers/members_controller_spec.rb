require 'spec_helper'

describe MembersController do
  
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
  end
  
  context "when current organisation is a company" do
    before(:each) do
      stub_company
      stub_login
    end
    
    describe "GET index" do
      before(:each) do
        @members_association = double("members association")
        @company.stub(:members).and_return(@members_association)
        
        @members = double("members")
        @members_association.stub(:active).and_return(@members)
        
        @director = mock_model(Director)
        Director.stub(:new).and_return(@director)
      end
      
      def get_index
        get :index
      end
      
      it "finds the active members" do
        @members_association.should_receive(:active).and_return(@members)
        get_index
      end
      
      it "assigns the members" do
        get_index
        assigns(:members).should == @members
      end
      
      it "builds a new director" do
        Director.should_receive(:new).and_return(@director)
        get_index
      end
      
      it "assigns the new director" do
        get_index
        assigns(:director).should == @director
      end
    end
  end
  
end
