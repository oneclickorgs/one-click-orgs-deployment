require 'spec_helper'

describe 'change_meeting_notice_period_resolutions/new' do

  before(:each) do
    @organisation = mock_model(Coop)
    view.stub(:co).and_return(@organisation)

    @constitution = mock("constitution")
    @organisation.stub(:constitution).and_return(@constitution)

    @constitution.stub(:meeting_notice_period)

    @change_meeting_notice_period_resolution = mock_model(ChangeMeetingNoticePeriodResolution,
      :meeting_notice_period => 14,
      :certification => nil,
      :pass_immediately => nil
    )

    assign(:change_meeting_notice_period_resolution, @change_meeting_notice_period_resolution)
  end

  it "renders a check box to immediately pass the resolution" do
    render
    rendered.should have_selector(:input, :name => 'change_meeting_notice_period_resolution[pass_immediately]')
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
