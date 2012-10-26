require 'spec_helper'

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
    rendered.should have_selector(:form, :action => '/members/3000/eject') do |form|
      form.should have_selector(:input, :name => '_method', :value => 'put')
      form.should have_selector(:input, :type => 'submit')
    end
  end

end
