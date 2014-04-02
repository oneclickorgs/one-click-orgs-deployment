require 'spec_helper'

describe 'associations/new' do

  before(:each) do
    set_up_app
  end

  it 'renders a T&Cs checkbox' do
    render
    expect(rendered).to have_selector("input[type='checkbox'][name='founder[terms_and_conditions]']")
  end

end
