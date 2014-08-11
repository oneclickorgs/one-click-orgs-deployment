require 'spec_helper'

describe RegistrationForm do

  let(:organisation) {mock_model(Organisation,
    name: 'Example Organisation',
    reg_form_timing_factors: nil,
    constitution: constitution,
    reg_form_close_links: nil,
    signatories: [],
    secretary: nil,
    reg_form_business_carried_out: nil,
    reg_form_funding: nil,
    reg_form_members_benefit: nil,
    reg_form_members_participate: nil,
    reg_form_members_control: nil,
    reg_form_profit_use: nil
  )}
  let(:registration_form) {RegistrationForm.new(organisation)}
  let(:constitution) {double('constitution', document: document)}
  let(:document) {mock_model(Rticles::Document,
    paragraph_numbers_for_topic: nil,
    paragraph_numbers_for_topics: nil
  )}

  describe 'financial year end' do
    it 'does not raise an error when processing an incorrect date format' do
      allow(organisation).to receive(:reg_form_financial_year_end).and_return('30 September')
      expect {registration_form.to_pdf}.to_not raise_error
    end
  end

end
