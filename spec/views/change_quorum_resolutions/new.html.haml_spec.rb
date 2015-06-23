require 'rails_helper'

describe 'change_quorum_resolutions/new' do

  before(:each) do
    @constitution = double("constitution",
      :quorum_number => 3,
      :quorum_percentage => 25
    )
    allow(view).to receive_message_chain(:co, :constitution).and_return(@constitution)

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
    expect(rendered).to have_selector("input[name='change_quorum_resolution[quorum_number]']")
  end

  it "renders a quorum_percentage field" do
    render
    expect(rendered).to have_selector("input[name='change_quorum_resolution[quorum_percentage]']")
  end

end
