class OfficershipMailer < OcoMailer
  def welcome_new_officer(officership)
    @officer = officership.officer
    @office_title = officership.office.title
    @organisation = officership.office.organisation
    @organisation_name = @organisation.name

    default_url_options[:host] = @organisation.domain(:only_host => true)

    create_mail(@organisation_name, @officer.email, "You have been made the #{@office_title} of #{@organisation_name}")
  end
end
