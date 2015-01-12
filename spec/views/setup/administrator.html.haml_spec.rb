require 'rails_helper'

describe 'setup/administrator' do

  let(:administrator) {mock_model(Administrator)}

  before(:each) do
    assign(:administrator, administrator)
  end

  it "renders an email field" do
    render
    expect(rendered).to have_selector(:input, name: 'administrator[email]')
  end

  it 'renders a password field' do
    render
    expect(rendered).to have_selector(:input, name: 'administrator[password]')
  end

  it 'renders a password confirmation field' do
    render
    expect(rendered).to have_selector(:input, name: 'administrator[password_confirmation]')
  end

  it 'renders a submit button' do
    render
    expect(rendered).to have_selector(:input, type: 'submit')
  end

end
