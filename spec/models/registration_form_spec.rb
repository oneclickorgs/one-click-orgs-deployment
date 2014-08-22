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
    reg_form_profit_use: nil,
    reg_form_financial_year_end: nil,
    objectives: nil
  )}
  let(:registration_form) {RegistrationForm.new(organisation)}
  let(:constitution) {double('constitution', document: document)}
  let(:document) {mock_model(Rticles::Document,
    paragraph_numbers_for_topic: nil,
    paragraph_numbers_for_topics: nil
  )}
  let(:form) { double('PdfFormFiller::Form',
    render: nil
  ) }

  describe 'financial year end' do
    it 'does not raise an error when processing an incorrect date format' do
      allow(organisation).to receive(:reg_form_financial_year_end).and_return('30 September')
      expect {registration_form.to_pdf}.to_not raise_error
    end
  end

  describe '"business_carried_out" field' do
    it 'is filled in with the "objectives" from the constitution' do
      allow(PdfFormFiller::Form).to receive(:new).and_return(form)
      allow(organisation).to receive(:objectives).and_return('Raise pigs in an environmentally-friendly manner.')
      expect(form).to receive(:fill_form).with(hash_including('business_carried_out' => 'Raise pigs in an environmentally-friendly manner.'))
      registration_form.to_pdf
    end

    it 'capitalizes the objectives' do
      allow(PdfFormFiller::Form).to receive(:new).and_return(form)
      allow(organisation).to receive(:objectives).and_return('raise pigs.')
      expect(form).to receive(:fill_form).with(hash_including('business_carried_out' => 'Raise pigs.'))
      registration_form.to_pdf
    end
  end

end
