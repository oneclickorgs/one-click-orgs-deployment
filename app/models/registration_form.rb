class RegistrationForm
  attr_accessor :organisation

  def initialize(organisation)
    self.organisation = organisation
  end

  def to_pdf
    template = File.expand_path(File.join(Rails.root, 'data', 'pdf_form_filler', 'fca', 'mutuals-new-ip-form.pdf'))
    definition = File.expand_path(File.join(Rails.root, 'data', 'pdf_form_filler', 'fca', 'mutuals-new-ip-form.yml'))

    # Load default filled-in data for form
    form_data = YAML.load_file(File.expand_path(File.join(Rails.root, 'data', 'pdf_form_filler', 'fca', 'mutuals-new-ip-form_data.yml')))

    # Customise the form data with this organisation's details
    form_data['organisation_name'] = "#{@organisation.name} Limited"

    form_data['contact_name'] = Setting[:coop_contact_name]
    form_data['contact_position'] = Setting[:coop_contact_position]
    form_data['contact_address'] = Setting[:coop_contact_address]
    form_data['contact_phone'] = Setting[:coop_contact_phone]
    form_data['contact_email'] = Setting[:coop_contact_email]

    form_data['timing_factors'] = @organisation.reg_form_timing_factors

    constitution_document = organisation.constitution.document

    form_data['name_rule_number'] = constitution_document.paragraph_numbers_for_topic('name', true)
    form_data['objects_rule_number'] = constitution_document.paragraph_numbers_for_topic('objects', true)
    form_data['registered_office_rule_number'] = constitution_document.paragraph_numbers_for_topic('registered_office', true)
    form_data['member_admission_rule_number'] = constitution_document.paragraph_numbers_for_topic('member_admission', true)
    form_data['meetings_rule_number'] = constitution_document.paragraph_numbers_for_topics(['meetings', 'proceedings'], true)
    form_data['board_rule_number'] = constitution_document.paragraph_numbers_for_topic('board', true)
    form_data['maximum_shareholding_rule_number'] = constitution_document.paragraph_numbers_for_topic('maximum_shareholding', true)
    form_data['loans_rule_number'] = constitution_document.paragraph_numbers_for_topic('loans', true)
    form_data['share_transactions'] = constitution_document.paragraph_numbers_for_topics(['share_transactions', 'maximum_shareholding'], true)
    form_data['audit_rule_number'] = constitution_document.paragraph_numbers_for_topic('audit', true)
    form_data['withdrawals_rule_number'] = constitution_document.paragraph_numbers_for_topic('withdrawals', true)
    form_data['profits_rule_number'] = constitution_document.paragraph_numbers_for_topic('profits', true)
    form_data['seal_rule_number'] = constitution_document.paragraph_numbers_for_topic('seal', true)
    form_data['investing_rule_number'] = constitution_document.paragraph_numbers_for_topic('investing', true)

    form_data['ips_type_explanation'] = <<-EOF
      #{constitution_document.paragraph_numbers_for_topic('objects', true)} Objects
      #{constitution_document.paragraph_numbers_for_topic('member_admission', true)} Membership
      #{constitution_document.paragraph_numbers_for_topic('proceedings', true)} Proceedings
      #{constitution_document.paragraph_numbers_for_topic('profits', true)} Application of profits
      #{constitution_document.paragraph_numbers_for_topic('dissolution', true)} Dissolution
    EOF

    year_end = @organisation.reg_form_financial_year_end
    if year_end.blank?
      form_data['year_end_day_1'] = ''
      form_data['year_end_day_2'] = ''
      form_data['year_end_month_1'] = ''
      form_data['year_end_month_2'] = ''
      form_data['year_end_year_1'] = ''
      form_data['year_end_year_2'] = ''
      form_data['year_end_year_3'] = ''
      form_data['year_end_year_4'] = ''
    else
      day, month, year = year_end.split('/').map(&:to_i)
      # Ensure each segment is formatted to the correct number of digits
      day = "%02d" % day
      month = "%02d" % month
      year = "%04d" % year

      # Use ranges for character access, for Ruby 1.8 and Ruby 1.9 compatibility.
      form_data['year_end_day_1'] = day[0..0]
      form_data['year_end_day_2'] = day[1..1]
      form_data['year_end_month_1'] = month[0..0]
      form_data['year_end_month_2'] = month[1..1]
      form_data['year_end_year_1'] = year[0..0]
      form_data['year_end_year_2'] = year[1..1]
      form_data['year_end_year_3'] = year[2..2]
      form_data['year_end_year_4'] = year[3..3]
    end

    form_data['membership_required_yes'] = true
    form_data['membership_required_no'] = false

    form_data['close_links'] = @organisation.reg_form_close_links

    first_three_members = @organisation.members.order('created_at ASC').limit(3)

    form_data['member_1_name'] = first_three_members[0].name
    form_data['member_1_address'] = first_three_members[0].address
    form_data['member_1_phone'] = first_three_members[0].phone

    form_data['member_2_name'] = first_three_members[1].name
    form_data['member_2_address'] = first_three_members[1].address
    form_data['member_2_phone'] = first_three_members[1].phone

    form_data['member_3_name'] = first_three_members[2].name
    form_data['member_3_address'] = first_three_members[2].address
    form_data['member_3_phone'] = first_three_members[2].phone

    form_data['secretary_name'] = @organisation.secretary.name
    form_data['secretary_address'] = @organisation.secretary.address
    form_data['secretary_phone'] = @organisation.secretary.phone

    form = PdfFormFiller::Form.new(:template => template, :definition => definition)
    form.fill_form(form_data)
    form.render
  end
end
