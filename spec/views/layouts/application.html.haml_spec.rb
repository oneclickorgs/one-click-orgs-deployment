require 'rails_helper'

describe "layouts/application" do
  before(:each) do
    controller.class_eval{include(ApplicationHelper)}
  end

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
        allow(view).to receive(:current_organisation).and_return(@organisation)
        allow(view).to receive(:co).and_return(@organisation)
        install_organisation_resolver(@organisation)

        @user = mock_model(Member, :name => "Lucy Baker", :inducted_at => 2.days.ago)
        allow(view).to receive(:current_user).and_return(@user)
        allow(controller).to receive(:current_user).and_return(@user)

        allow(@user).to receive(:has_permission).with(:freeform_proposal).and_return(false)
        allow(@user).to receive(:has_permission).with(:membership_proposal).and_return(false)
        allow(@user).to receive(:has_permission).with(:constitution_proposal).and_return(false)
        allow(@user).to receive(:has_permission).with(:found_association_proposal).and_return(false)
        allow(@user).to receive(:has_permission).with(:vote).and_return(false)
        allow(@user).to receive(:organisation).and_return(@organisation)
      end

      it "should show a link to let users log out" do
        render
        expect(rendered).to have_selector('a[href="/logout"]')
      end

      context "when assocation is pending" do
        before(:each) do
          allow(@organisation).to receive(:pending?).and_return(true)
          allow(@organisation).to receive(:can_hold_founding_vote?).and_return(true)
        end

        context "when user is the founder" do
          before(:each) do
            allow(@members_association).to receive(:first).and_return(@user)
            allow(@user).to receive(:has_permission).with(:member_proposal).and_return(true)
            allow(@user).to receive(:has_permission).with(:found_association_proposal).and_return(true)
          end

          it "displays a button to hold the founding vote" do
            render
            expect(rendered).to have_selector("form[action='/found_association_proposals'][id='start_founding_vote_form']") do |form|
              expect(form).to have_selector("input[type='submit']")
            end
          end

          context "when association is ready to hold founding vote" do
            before(:each) do
              allow(@organisation).to receive(:can_hold_founding_vote?).and_return(true)
            end

            it "sets up a lightbox for the start_founding_vote_confirmation message" do
              render
              expect(rendered).to have_selector("script[src*='start_founding_vote_confirmation.js']", visible: false)
              expect(rendered).to have_selector('#start_founding_vote_confirmation_lightbox', visible: false)
            end
          end

          context "when association is not yet ready to hold founding vote" do
            before(:each) do
              allow(@organisation).to receive(:can_hold_founding_vote?).and_return(false)
            end

            it "sets up a lightbox for the start_founding_vote_alert message" do
              render
              expect(rendered).to have_selector("script[src*='start_founding_vote_alert.js']", visible:false)
              expect(rendered).to have_selector('#start_founding_vote_alert_lightbox', visible: false)
            end
          end
        end
      end

      context "when association is proposed" do
        before(:each) do
          allow(@organisation).to receive(:proposed?).and_return(true)
          allow(@organisation).to receive(:pending?).and_return(false)

          @found_association_proposal = mock_model(FoundAssociationProposal,
            :close_date => 3.days.from_now,
            :vote_by => false,
            :description => ''
          )

          @found_association_proposals_association = double('found association proposals association')
          allow(@organisation).to receive(:found_association_proposals).and_return(@found_association_proposals_association)
          allow(@found_association_proposals_association).to receive(:last).and_return(@found_association_proposal)

          allow(@user).to receive(:eligible_to_vote?).and_return(true)
          allow(@user).to receive(:has_permission).with(:vote).and_return(true)
        end

        context "when user has not voted yet" do
          before(:each) do
            allow(@found_association_proposal).to receive(:vote_by).and_return(false)
          end

          it "displays support and oppose buttons in the overlay" do
            render
            expect(rendered).to have_selector('#overlay') do |overlay|
              expect(overlay).to have_selector("form[action*='/votes/vote_for/#{@found_association_proposal.id}']")
              expect(overlay).to have_selector("form[action*='/votes/vote_against/#{@found_association_proposal.id}']")
            end
          end
        end

        context "when user has voted already" do
          before(:each) do
            allow(@found_association_proposal).to receive(:vote_by).and_return(true)
          end

          it "does not display support and oppose buttons in the overlay" do
            render
            expect(rendered).to have_selector('#overlay') do |overlay|
              expect(overlay).not_to have_selector("form[action*='/votes/vote_for']")
              expect(overlay).not_to have_selector("form[action*='/votes/vote_against']")
            end
          end
        end
      end
    end
  end
end
