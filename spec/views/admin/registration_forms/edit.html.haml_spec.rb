require 'spec_helper'

describe 'admin/registration_forms/edit' do

  let(:organisation) {mock_model(Organisation, :name => 'Acme')}

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
