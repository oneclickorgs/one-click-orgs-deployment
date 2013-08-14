require 'spec_helper'

describe "layouts/application" do
  context "when current organisation is an association" do
    context "when user is logged in" do
      before(:each) do
        @members_association = double('members association', :first => @founder = mock_model(Member, :name => "Bob Smith"))

        @organisation = mock_model(Association,
          :name => "The Cheese Collective",
          :members => @members_association,
          :pending? => false,
          :proposed? => false,
          :can_hold_founding_vote? => false
        )

        assign(:current_organisation, @organisation)
        view.stub(:current_organisation).and_return(@organisation)
        view.stub(:co).and_return(@organisation)
        install_organisation_resolver(@organisation)

        @user = mock_model(Member, :name => "Lucy Baker", :inducted_at => 2.days.ago)
        view.stub(:current_user).and_return(@user)
        controller.stub(:current_user).and_return(@user)

        @user.stub(:has_permission).with(:freeform_proposal).and_return(false)
        @user.stub(:has_permission).with(:membership_proposal).and_return(false)
        @user.stub(:has_permission).with(:constitution_proposal).and_return(false)
        @user.stub(:has_permission).with(:found_association_proposal).and_return(false)
        @user.stub(:has_permission).with(:vote).and_return(false)
        @user.stub(:organisation).and_return(@organisation)
      end

      it "should show a link to let users log out" do
        render
        rendered.should have_selector('a[href="/logout"]')
      end

      context "when assocation is pending" do
        before(:each) do
          @organisation.stub(:pending?).and_return(true)
          @organisation.stub(:can_hold_founding_vote?).and_return(true)
        end

        context "when user is the founder" do
          before(:each) do
            @members_association.stub(:first).and_return(@user)
            @user.stub(:has_permission).with(:member_proposal).and_return(true)
            @user.stub(:has_permission).with(:found_association_proposal).and_return(true)
          end

          it "displays a button to hold the founding vote" do
            render
            rendered.should have_selector('form', :action => '/found_association_proposals', :id => 'start_founding_vote_form') do |form|
              form.should have_selector('input', :type => 'submit')
            end
          end

          context "when association is ready to hold founding vote" do
            before(:each) do
              @organisation.stub(:can_hold_founding_vote?).and_return(true)
            end

            it "sets up a lightbox for the start_founding_vote_confirmation message" do
              render
              rendered.should have_selector("script[src*='start_founding_vote_confirmation.js']")
              rendered.should have_selector('#start_founding_vote_confirmation_lightbox')
            end
          end

          context "when association is not yet ready to hold founding vote" do
            before(:each) do
              @organisation.stub(:can_hold_founding_vote?).and_return(false)
            end

            it "sets up a lightbox for the start_founding_vote_alert message" do
              render
              rendered.should have_selector("script[src*='start_founding_vote_alert.js']")
              rendered.should have_selector('#start_founding_vote_alert_lightbox')
            end
          end
        end
      end

      context "when association is proposed" do
        before(:each) do
          @organisation.stub(:proposed?).and_return(true)
          @organisation.stub(:pending?).and_return(false)

          @found_association_proposal = mock_model(FoundAssociationProposal,
            :close_date => 3.days.from_now,
            :vote_by => false,
            :description => ''
          )

          @found_association_proposals_association = double('found association proposals association')
          @organisation.stub(:found_association_proposals).and_return(@found_association_proposals_association)
          @found_association_proposals_association.stub(:last).and_return(@found_association_proposal)

          @user.stub(:eligible_to_vote?).and_return(true)
          @user.stub(:has_permission).with(:vote).and_return(true)
        end

        context "when user has not voted yet" do
          before(:each) do
            @found_association_proposal.stub(:vote_by).and_return(false)
          end

          it "displays support and oppose buttons in the overlay" do
            render
            rendered.should have_selector('#overlay') do |overlay|
              overlay.should have_selector("form[action*='/votes/vote_for/#{@found_association_proposal.id}']")
              overlay.should have_selector("form[action*='/votes/vote_against/#{@found_association_proposal.id}']")
            end
          end
        end

        context "when user has voted already" do
          before(:each) do
            @found_association_proposal.stub(:vote_by).and_return(true)
          end

          it "does not display support and oppose buttons in the overlay" do
            render
            rendered.should have_selector('#overlay') do |overlay|
              overlay.should_not have_selector("form[action*='/votes/vote_for']")
              overlay.should_not have_selector("form[action*='/votes/vote_against']")
            end
          end
        end
      end
    end
  end
end
