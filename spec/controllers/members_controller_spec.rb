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
        @directors_association = double("directors association")
        @company.stub(:directors).and_return(@directors_association)
        
        @directors = double("directors")
        @directors_association.stub(:active).and_return(@directors)
        
        @director = mock_model(Director)
        Director.stub(:new).and_return(@director)
      end
      
      def get_index
        get :index
      end
      
      it "finds the active directors" do
        @directors_association.should_receive(:active).and_return(@directors)
        get_index
      end
      
      it "assigns the directors" do
        get_index
        assigns(:members).should == @directors
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
