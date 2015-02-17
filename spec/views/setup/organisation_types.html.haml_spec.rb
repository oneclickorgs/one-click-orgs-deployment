require 'rails_helper'

describe 'setup/organisation_types' do

  it 'renders a form that submits to /setup/set_organisation_types' do
    render
    expect(rendered).to have_selector("form[action='/setup/set_organisation_types']")
  end

  it 'renders an association checkbox' do
    render
    expect(rendered).to have_selector("input[type='checkbox'][name='association']")
    expect(rendered).to have_selector("label[for='association']", text: 'Associations')
  end

  it 'renders a CLG checkbox' do
    render
    expect(rendered).to have_selector("input[type='checkbox'][name='company']")
    expect(rendered).to have_selector("label[for='company']", text: 'Companies Limited by Guarantee')
  end

  it 'renders a co-op checkbox' do
    render
    expect(rendered).to have_selector("input[type='checkbox'][name='coop']")
    expect(rendered).to have_selector("label[for='coop']", text: 'Co-operatives')
  end

  it 'renders a submit button' do
    render
    expect(rendered).to have_selector("input[type='submit'][value='Save settings']")
  end

end
