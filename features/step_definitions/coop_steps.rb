Given(/^there is a draft co\-op$/) do
  set_up_application_if_necessary

  @coop = @organisation = Coop.make!(:pending)

  founder = @coop.members.make!(:founder_member)

  set_subdomain_to_organisation
end

Given(/^there is a co\-op$/) do
  set_up_application_if_necessary

  @coop = @organisation = Coop.make!

  secretary = @coop.members.make!(:secretary)
  secretary_office = @coop.offices.make!(:title => "Secretary")
  secretary_office.officership = Officership.make!(:officer => secretary)

  @coop.members.make!(:director)

  set_subdomain_to_organisation
end

When(/^I enter my details$/) do
  fill_in("First name", :with => "Bob")
  fill_in("Last name", :with => "Smith")
  fill_in("Email address", :with => "bob@example.com")
  fill_in("Choose password", :with => "letmein")
  fill_in("Confirm password", :with => "letmein")
end

When(/^I enter the new co\-op's details$/) do
  fill_in("Co-op's official name", :with => "Coffee Ventures")
  fill_in("Your One Click Orgs web address will be", :with => "coffee")
  fill_in("What the Co-op exists for", :with => "Selling coffee")
end

When(/^the co\-op daily job runs$/) do
  Coop.run_daily_job
end

When(/^I accept the Terms of Use$/) do
  check('I accept the Terms of Use.')
end
