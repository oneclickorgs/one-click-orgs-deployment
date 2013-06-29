require 'pdf_form_filler'
require 'yaml'

class RegistrationFormsController < ApplicationController
  def show
    respond_to do |format|
      format.pdf do
        template = File.expand_path(File.join(Rails.root, 'data', 'pdf_form_filler', 'fsa_ips', 'ms_application_form.pdf'))
        definition = File.expand_path(File.join(Rails.root, 'data', 'pdf_form_filler', 'fsa_ips', 'ms_application_form.yml'))

        # Load default filled-in data for form
        form_data = YAML.load_file(File.expand_path(File.join(Rails.root, 'data', 'pdf_form_filler', 'fsa_ips', 'ms_application_form_data.yml')))

        # Customise the form data with this organisation's details
        form_data['organisation_name'] = "#{co.name} Limited"

        form_data['contact_name'] = Setting[:coop_contact_name]
        form_data['contact_position'] = Setting[:coop_contact_position]
        form_data['contact_address'] = Setting[:coop_contact_address]
        form_data['contact_phone'] = Setting[:coop_contact_phone]
        form_data['contact_email'] = Setting[:coop_contact_email]

        form_data['timing_factors'] = co.reg_form_timing_factors

        year_end = co.reg_form_financial_year_end
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

        if co.reg_form_membership_required
          form_data['membership_required_yes'] = true
          form_data['membership_required_no'] = false
        else
          form_data['membership_required_yes'] = false
          form_data['membership_required_no'] = true
        end

        form_data['ips_type_explanation'] = <<-EOF
          5 Objects
          15-20 Membership
          29-30 Proceedings
          113 Application of profits
          116 Dissolution
        EOF

        form_data['close_links'] = co.reg_form_close_links

        first_three_members = co.members.order('created_at ASC').limit(3)

        form_data['member_1_name'] = first_three_members[0].name
        form_data['member_1_address'] = first_three_members[0].address
        form_data['member_1_phone'] = first_three_members[0].phone

        form_data['member_2_name'] = first_three_members[1].name
        form_data['member_2_address'] = first_three_members[1].address
        form_data['member_2_phone'] = first_three_members[1].phone

        form_data['member_3_name'] = first_three_members[2].name
        form_data['member_3_address'] = first_three_members[2].address
        form_data['member_3_phone'] = first_three_members[2].phone

        form_data['secretary_name'] = co.secretary.name
        form_data['secretary_address'] = co.secretary.address
        form_data['secretary_phone'] = co.secretary.phone

        form = PdfFormFiller::Form.new(:template => template, :definition => definition)
        form.fill_form(form_data)
        pdf = form.render

        send_data(pdf, :filename => "#{co.name} Registration Form.pdf",
          :type => 'application/pdf', :disposition => 'attachment')
      end
    end
  end

  def edit
    @registration_form = co
  end

  def update
    @registration_form = co

    @registration_form.reg_form_timing_factors = params[:registration_form][:reg_form_timing_factors]
    @registration_form.reg_form_financial_year_end = params[:registration_form][:reg_form_financial_year_end]
    @registration_form.reg_form_membership_required = case params[:registration_form][:reg_form_membership_required]
    when 'true'
      true
    when 'false'
      false
    else
      nil
    end
    @registration_form.reg_form_close_links = params[:registration_form][:reg_form_close_links]

    if @registration_form.save
      flash[:notice] = "Your changes to the Registration Form were saved."
    else
      flash[:error] = "There was a problem saving your changes to the Registration Form: #{@registration_form.errors.full_messages.to_sentence}"
    end
    redirect_to edit_registration_form_path
  end
end
