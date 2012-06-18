Given /^the domain is the organisation's domain$/ do
  step %Q{the domain is "#{@organisation.host}"}
end

Given /^the subdomain is the organisation's subdomain$/ do
  step %Q{the subdomain is "#{@organisation.subdomain}"}
end

Given /^the organisation's name is "([^"]*)"$/ do |new_organisation_name|
  @organisation ||= Organisation.last
  @organisation.clauses.set_text!(:organisation_name, new_organisation_name)
end

When /^I choose to create an association$/ do
  click_link "Association"
end

When /^I choose to create a company$/ do
  click_link "Company"
end

When /^I choose to create a co\-op$/ do
  click_link "Co-operative"
end

Then /^I should see a list of recent activity$/ do
  page.should have_css('table.timeline td.timestamp')
end

Then /^I should see a list of types of organisation$/ do
  page.should have_css('ul.organisations')
end
