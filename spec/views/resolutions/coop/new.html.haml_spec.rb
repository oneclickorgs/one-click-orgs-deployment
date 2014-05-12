require 'spec_helper'

describe "resolutions/coop/new" do

  before(:each) do
    @resolution = mock_model(Resolution,
      :draft => nil,
      :voting_period_in_days => 14,
      :extraordinary => nil,
      :certification => nil
    )
    assign(:resolution, @resolution)
  end

  it "renders a list of links to different types of proposal" do
    render
    rendered.should have_selector(:a, :href => '/change_meeting_notice_period_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_quorum_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_name_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_registered_office_address_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_objectives_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_membership_criteria_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_board_composition_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_single_shareholding_resolutions/new')
    rendered.should have_selector(:a, :href => '/change_common_ownership_resolutions/new')
    rendered.should have_selector(:a, :href => '/terminate_directorship_resolutions/new')
    rendered.should have_selector(:a, :href => '/generic_resolutions/new')
  end

end
