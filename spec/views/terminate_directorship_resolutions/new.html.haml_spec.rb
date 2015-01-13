require 'rails_helper'

describe 'terminate_directorship_resolutions/new' do

  let(:terminate_directorship_resolution) {mock_model(TerminateDirectorshipResolution, director_id: nil)}

  let(:directors_for_select) {[
    ['Ann Ackerman', 1],
    ['Bob Baker', 2]
  ]}

  before(:each) do
    assign(:terminate_directorship_resolution, terminate_directorship_resolution)
    assign(:directors_for_select, directors_for_select)
  end

  it 'renders a select field of directors' do
    render
    expect(rendered).to have_selector("select[name='terminate_directorship_resolution[director_id]']") do |select|
      expect(select).to have_selector("option[value='1'][content='Ann Ackerman']")
      expect(select).to have_selector("option[value='2'][content='Bob Baker']")
    end
  end

end
