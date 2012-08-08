class DirectorshipMailer < OcoMailer
  def welcome_new_director(directorship)
    default_url_options[:host] = directorship.organisation.domain(:only_host => true)

    @director = directorship.director
    @organisation = directorship.organisation
    @organisation_name = @organisation.name

    create_mail(@organisation_name, @director.email, "You have been made a Director of #{@organisation_name}")
  end
end
