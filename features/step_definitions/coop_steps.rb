Given /^there is a draft co\-op$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^there is a co\-op$/ do
  set_up_application_if_necessary

  @coop = @organisation = Coop.make!

  secretary = @coop.members.make!(:secretary)
  secretary_office = @coop.offices.make!(:title => "Secretary")
  secretary_office.officership = Officership.make!(:officer => secretary)

  @coop.members.make!(:director)

  set_subdomain_to_organisation
end
