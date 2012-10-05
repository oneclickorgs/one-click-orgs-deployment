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

  it "renders a description text area for the resolution" do
    render
    rendered.should have_css("textarea[name='resolution[description]']")
  end

end
