require 'spec_helper'

describe 'change_meeting_notice_period_resolutions/new' do

  before(:each) do
    @organisation = mock_model(Coop)
    allow(view).to receive(:co).and_return(@organisation)

    @constitution = double("constitution")
    allow(@organisation).to receive(:constitution).and_return(@constitution)

    allow(@constitution).to receive(:meeting_notice_period)

    @change_meeting_notice_period_resolution = mock_model(ChangeMeetingNoticePeriodResolution,
      :meeting_notice_period => 14,
      :certification => nil,
      :pass_immediately => nil
    )

    assign(:change_meeting_notice_period_resolution, @change_meeting_notice_period_resolution)
  end

  it "renders a check box to immediately pass the resolution" do
    render
    expect(rendered).to have_selector(:input, :name => 'change_meeting_notice_period_resolution[pass_immediately]')
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector(:input, :type => 'submit')
  end

end
