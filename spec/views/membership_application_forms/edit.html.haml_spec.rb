require 'spec_helper'

describe 'membership_application_forms/edit' do
  it "renders a field for the membership application form's custom text" do
    render
    rendered.should have_selector(:textarea, :name => 'organisation[membership_application_text]')
  end
end
