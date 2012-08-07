require 'spec_helper'

describe 'general_meetings/show' do

  context "when general meeting happened in the past" do
    let(:general_meeting) {mock_model(GeneralMeeting,
      :past? => true,
      :minutes => "We discussed things.",
      :participants => [
        mock_model(Member, :name => "John Smith"),
        mock_model(Member, :name => "Sally Baker")
      ]
    )}

    before(:each) do
      assign(:general_meeting, general_meeting)
    end

    it "renders the minutes" do
      render
      rendered.should have_content("We discussed things.")
    end

    it "renders a list of participants" do
      render
      rendered.should have_selector('.participants') do |participants|
        participants.should have_content("John Smith")
        participants.should have_content("Sally Baker")
      end
    end
  end

end
