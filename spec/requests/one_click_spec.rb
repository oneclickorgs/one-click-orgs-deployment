require 'spec_helper'

describe "/one_click" do
  before(:each) do
    stub_constitution!
    stub_organisation!
  end
  
  describe "dashboard" do
    before(:each) do
      login
    end
    
    it "should display a timeline with past events" do
      @organisation.members.make 
      @organisation.proposals.make
      @organisation.proposals.make.create_decision
      
      get url_for(:controller => 'one_click', :action => 'dashboard')
      @response.should be_successful
      @response.should have_xpath("//table[@class='timeline']")
    end
  end
end