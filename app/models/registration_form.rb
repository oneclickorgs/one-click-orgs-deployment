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

    form_data['ips_type_explanation'] = <<-EOF
      5 Objects
      15-20 Membership
      29-30 Proceedings
      113 Application of profits
      116 Dissolution
    EOF

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
