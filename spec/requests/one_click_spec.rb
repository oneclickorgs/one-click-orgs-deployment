require 'rails_helper'

describe "/one_click" do

  include RequestSpecHelper
  
  context "when current organisation is an association" do
    before(:each) do
      default_association_constitution
      default_association
    end

    describe "dashboard" do
      before(:each) do
        association_login
      end

      it "should display a timeline with past events" do
        @organisation.members.make!
        @organisation.proposals.make!
        @organisation.proposals.make!.create_decision

        get url_for(:controller => 'one_click', :action => 'dashboard')
        expect(@response).to be_successful
        expect(page).to have_xpath("//table[@class='timeline']")
      end
    end
  end
  
end