require 'spec_helper'

describe "layouts/application.html.haml" do
  context "when user is logged in" do
    before(:each) do
      @members_association = mock('members association', :first => @founder = mock_model(Member, :name => "Bob Smith"))
      
      @organisation = mock_model(Organisation,
        :name => "The Cheese Collective",
        :members => @members_association,
        :proposed? => false,
        :can_hold_founding_vote? => false
      )
      
      assign(:current_organisation, @organisation)
      view.stub!(:current_organisation).and_return(@organisation)
      view.stub!(:co).and_return(@organisation)
      
      view.stub!(:current_user).and_return(@user = mock_model(Member, :name => "Lucy Baker"))
    end
    
    context "when organisation is pending" do
      before(:each) do
        @organisation.stub!(:pending?).and_return(true)
        @organisation.stub!(:can_hold_founding_vote?).and_return(true)
      end
      
      context "when user is the founder" do
        before(:each) do
          @members_association.stub!(:first).and_return(@user)
          @user.stub!(:has_permission).with(:found_organisation_proposal).and_return(true)
        end
        
        it "displays a button to hold the founding vote" do
          render
          rendered.should have_selector('form', :action => '/proposals/propose_foundation', :id => 'start_founding_vote_form') do |form|
            form.should have_selector('input', :type => 'submit')
          end
        end
        
        context "when organisation is ready to hold founding vote" do
          before(:each) do
            @organisation.stub!(:can_hold_founding_vote?).and_return(true)
          end
          
          it "sets up a lightbox for the start_founding_vote_confirmation message" do
            render
            rendered.should have_selector("script[src*='start_founding_vote_confirmation.js']")
            rendered.should have_selector('#start_founding_vote_confirmation_lightbox')
          end
        end
        
        context "when organisation is not yet ready to hold founding vote" do
          before(:each) do
            @organisation.stub!(:can_hold_founding_vote?).and_return(false)
          end
          
          it "sets up a lightbox for the start_founding_vote_alert message" do
            render
            rendered.should have_selector("script[src*='start_founding_vote_alert.js']")
            rendered.should have_selector('#start_founding_vote_alert_lightbox')
          end
        end
      end
    end
  end
end
