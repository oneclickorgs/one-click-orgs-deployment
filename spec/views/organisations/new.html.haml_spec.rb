require 'rails_helper'

describe 'organisations/new' do

  before(:each) do
    assign(:association_enabled, true)
    assign(:company_enabled, false)
    assign(:coop_enabled, true)
  end

  it 'renders links to the new action for each enabled organisation type' do
    render
    expect(rendered).to have_selector("a[href='/associations/new']")
    expect(rendered).to have_selector("a[href='/coops/new']")
  end

  it 'does not render links to the new actions for disabled organisation types' do
    render
    expect(rendered).to_not have_selector("a[href='/companies/new']")
  end

end
