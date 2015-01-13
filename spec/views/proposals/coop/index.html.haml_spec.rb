require 'rails_helper'

describe "proposals/coop/index" do

  before(:each) do
    allow(view).to receive(:can?).and_return(false)

    @proposals = [mock_model(Resolution, :description => "Open proposal description", :end_date => 14.days.from_now)]
    assign(:proposals, @proposals)

    @draft_proposals = [mock_model(Resolution,
      :title => "Draft proposal title",
      :description => "Draft proposal description"
    )]
    assign(:draft_proposals, @draft_proposals)

    @resolution_proposals = [mock_model(ResolutionProposal, :description => "Suggested resolution description")]
    assign(:resolution_proposals, @resolution_proposals)

    stub_template "proposals/_vote" => "vote partial"
  end

  it "renders a list of currently-open proposals" do
    render
    expect(rendered).to have_selector('.proposals', :content => "Open proposal description")
  end

  context "when user can vote on an open proposal" do
    before(:each) do
      @proposal = @proposals.first
      allow(view).to receive(:can?).with(:vote_on, @proposal).and_return(true)
    end

    it "renders the voting partial for each open proposal" do
      render
      expect(rendered).to include("vote partial")
    end
  end

  context "when user can create a resolution" do
    before(:each) do
      allow(view).to receive(:can?).with(:edit, ResolutionProposal).and_return(true)
      allow(view).to receive(:can?).with(:create, Resolution).and_return(true)
    end

    it "renders a list of draft resolutions" do
      render
      expect(rendered).to have_selector('.draft_proposals', :content => "Draft proposal description")
    end

    it "includes the description in the list of draft resolutions" do
      render
      expect(rendered).to include('Draft proposal description')
    end

    it "renders a button to create a resolution" do
      render
      expect(rendered).to have_css("form[action='/resolutions/new']")
    end

    it "renders a 'Start an electronic vote' button for each draft resolution" do
      render
      expect(rendered).to have_selector(".draft_proposals form[action='/proposals/#{@draft_proposals[0].to_param}/open']")
    end

    it "renders a 'Start an electronic vote' button for each suggested resolution" do
      render
      expect(rendered).to have_selector(".resolution_proposals form[action='/resolution_proposals/#{@resolution_proposals[0].to_param}/pass']")
    end
  end

  context "when user can edit a resolution proposal" do
    before(:each) do
      allow(view).to receive(:can?).with(:edit, ResolutionProposal).and_return(true)
    end

    it "renders a list of suggested resolutions" do
      render
      expect(rendered).to have_selector('.resolution_proposals', :content => "Suggested resolution description")
    end

    it "renders an edit button for each suggested resolution" do
      render
      expect(rendered).to have_selector(".resolution_proposals form[action='/resolution_proposals/#{@resolution_proposals[0].to_param}/edit']")
    end
  end

  context "when user can create a meeting" do
    before(:each) do
      allow(view).to receive(:can?).with(:edit, ResolutionProposal).and_return(true)
      allow(view).to receive(:can?).with(:create, Meeting).and_return(true)
    end

    it "renders an 'Add to a meeting' button for each draft resolution" do
      render
      expect(rendered).to have_selector(".draft_proposals form[action='/general_meetings/new?resolution_id=#{@draft_proposals[0].to_param}']")
    end
  end

  context "when user can create a meeting and can create a resolution" do
    before(:each) do
      allow(view).to receive(:can?).with(:edit, ResolutionProposal).and_return(true)
      allow(view).to receive(:can?).with(:create, Meeting).and_return(true)
      allow(view).to receive(:can?).with(:create, Resolution).and_return(true)
    end

    it "renders an 'Add to a meeting' button for each suggested resolution" do
      render
      expect(rendered).to have_selector(".resolution_proposals form[action='/resolution_proposals/#{@resolution_proposals[0].to_param}/pass_to_meeting']")
    end
  end

  context "when user cannot create a resolution" do
    it "does not render a button to create a resolution"
    it "does not render a button to start an electronic vote for each draft resolution"
  end

  context "when user can suggest a resolution" do
    before(:each) do
      allow(view).to receive(:can?).with(:create, ResolutionProposal).and_return(true)
    end

    it "renders a button to create a suggested resolution" do
      render
      expect(rendered).to have_css("form[action='/resolution_proposals/new']")
    end
  end
end
