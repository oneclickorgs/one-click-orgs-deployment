Given /^the domain is the organisation's domain$/ do
  Given %Q{the domain is "#{@organisation.host}"}
end

Given /^the subdomain is the organisation's subdomain$/ do
  Given %Q{the subdomain is "#{@organisation.subdomain}"}
end


Given /^the organisation's name is "([^"]*)"$/ do |new_organisation_name|
  @organisation ||= Organisation.last
  @organisation.clauses.set_text!(:organisation_name, new_organisation_name)
end

Then /^I should see a list of recent activity$/ do
  page.should have_css('table.timeline td.timestamp')
end
