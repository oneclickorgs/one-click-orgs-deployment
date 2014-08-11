require 'spec_helper'

describe 'admin/registration_forms/edit' do

  let(:organisation) {mock_model(Organisation,
    name: 'Acme',
    reg_form_business_carried_out: nil,
    reg_form_funding: nil,
    reg_form_members_benefit: nil,
    reg_form_members_participate: nil,
    reg_form_members_control: nil,
    reg_form_profit_use: nil
  )}

  before(:each) do
    assign(:organisation, organisation)
    assign(:registration_form, organisation)

    stub_template 'registration_forms/_form' => 'registration form form'
  end

  it "renders registration_forms/form" do
    render
    expect(rendered).to render_template('registration_forms/_form')
  end

end
