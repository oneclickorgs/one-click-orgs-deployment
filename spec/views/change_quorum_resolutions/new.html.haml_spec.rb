require 'spec_helper'

describe 'change_quorum_resolutions/new' do

  before(:each) do
    @constitution = mock("constitution",
      :quorum_number => 3,
      :quorum_percentage => 25
    )
    view.stub_chain(:co, :constitution).and_return(@constitution)

    @change_quorum_resolution = mock_model(ChangeQuorumResolution,
      :quorum_number => nil,
      :quorum_percentage => nil,
      :certification => nil,
      :pass_immediately => nil
    )
    assign(:change_quorum_resolution, @change_quorum_resolution)
  end

  it "renders a quorum_number field" do
    render
    rendered.should have_selector(:input, :name => 'change_quorum_resolution[quorum_number]')
  end

  it "renders a quorum_percentage field" do
    render
    rendered.should have_selector(:input, :name => 'change_quorum_resolution[quorum_percentage]')
  end

end
