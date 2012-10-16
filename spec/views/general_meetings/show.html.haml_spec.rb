require 'spec_helper'

describe 'general_meetings/show' do

  context "when general meeting happened in the past" do
    let(:general_meeting) {mock_model(GeneralMeeting,
      :past? => true,
      :minutes => "We discussed things.",
      :participants => [
        mock_model(Member, :name => "John Smith"),
        mock_model(Member, :name => "Sally Baker")
      ],
      :agenda_items => [
        mock_model(AgendaItem,
          :title => "Any Other Business",
          :minutes => "Thanks to John Smith for providing the refreshments."
        )
      ],
      :happened_on => 1.week.ago,
      :minuted? => true
    )}

    before(:each) do
      assign(:general_meeting, general_meeting)
    end

    it "renders the minutes for each agenda item" do
      render
      rendered.should have_content("Any Other Business")
      rendered.should have_content("Thanks to John Smith for providing the refreshments.")
    end

    it "renders the general minutes" do
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

  context "when general meeting is upcoming" do
    let(:general_meeting) {
      mock_model(GeneralMeeting,
        :past? => false,
        :agenda_items => [
          mock_model(AgendaItem, :title => "Apologies for Absence"),
          mock_model(AgendaItem, :title => "Any Other Business")
        ],
        :happened_on => 2.days.from_now
      )
    }

    before(:each) do
      assign(:general_meeting, general_meeting)
    end

    it "renders the agenda items" do
      render
      rendered.should have_selector("ol.agenda_items") do |ol|
        ol.should have_selector(:li, :content => "Apologies for Absence")
        ol.should have_selector(:li, :content => "Any Other Business")
      end
    end
  end

end
