require 'rails_helper'

describe 'members/coop/confirm_eject' do

  let(:member) {mock_model(Member,
    :name => "Bob Smith",
    :to_param => '3000'
  )}

  before(:each) do
    assign(:member, member)
  end

  it "renders a submit button for the eject form" do
    render
    expect(rendered).to have_selector("form[action='/members/3000/eject']") do |form|
      expect(form).to have_selector(:input, :name => '_method', :value => 'put')
      expect(form).to have_selector("input[type='submit']")
    end
  end

end
