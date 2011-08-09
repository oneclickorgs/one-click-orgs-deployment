require 'spec_helper'

describe DirectorsController do
  
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
    stub_company
    stub_login
  end
  
  describe "POST create" do
    before(:each) do
      @director_parameters = double("director parameters")
      @director = mock_model(Director, :save => true, :send_welcome= => nil).as_new_record
      @director.stub(:send_new_director_notifications)
      @company.stub(:build_director).and_return(@director)
    end
    
    def post_create
      post :create, 'director' => @director_parameters
    end
    
    it "builds a new director" do
      @company.should_receive(:build_director).with(@director_parameters).and_return(@director)
      post_create
    end
    
    it "saves the new director" do
      @director.should_receive(:save).and_return(true)
      post_create
    end
    
    it "sends notification emails to all directors" do
			@director.should_receive(:send_new_director_notifications)
      post_create
    end
    
    it "redirects to the members page" do
      post_create
      response.should redirect_to('/members')
    end
    
    context "when director cannot be saved" do
      it "handles the error gracefully"
    end
    
    it "checks permissions"
  end
  
  describe "POST stand_down" do
    before(:each) do
      @directors_association = double("directors association")
      @company.stub!(:directors).and_return(@directors_association)

      @director = mock_model(Director, :update_attributes => true, :eject! => true)
      @directors_association.stub!(:find).and_return(@director)
      
      @director_parameters = {"stood_down_on(1i)"=>"2011", "stood_down_on(2i)"=>"8", "stood_down_on(3i)"=>"6", "certification"=>"1"}
    end
    
    def post_stand_down
      post :stand_down, :id => '1', :director => @director_parameters
    end
    
    it "finds the director" do
      @directors_association.should_receive(:find).with('1').and_return(@director)
      post_stand_down
    end
    
    it "updates the directors attributes" do
      @director.should_receive(:update_attributes).with(@director_parameters)
      post_stand_down
    end
    
    it "ejects the director" do
      @director.should_receive(:eject!)
      post_stand_down
    end
    
    it "redirects to the members_page" do
      post_stand_down
      response.should redirect_to('/members')
    end
  end
  
end
