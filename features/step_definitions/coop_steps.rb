Given /^there is a draft co\-op$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^there is a co\-op$/ do
  set_up_application_if_necessary
  @coop = @organisation = Coop.make!
  @coop.members.make!(:secretary)
  @coop.members.make!(:director)
  set_subdomain_to_organisation
end
