require 'spec_helper'

describe "layouts/welcome" do
  
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
      
      allow(view).to receive(:current_user).and_return(@user = mock_model(Member,
                                                              :name => "Lucy Baker",
                                                              :inducted_at => 2.days.ago
                                                             ))
    end

    it "should show a link to let users log out on the join organisation page" do
      render
      expect(rendered).to have_selector('a[href="/logout"]')
    end
  end

end
