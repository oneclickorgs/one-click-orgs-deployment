def set_domain(domain)
  if Capybara.current_driver == :selenium
    Capybara.default_host = "http://#{domain}:#{Capybara.server_port}"
    Capybara.app_host = "http://#{domain}:#{Capybara.server_port}"
  else
    Capybara.default_host = "http://#{domain}:#{Capybara.server_port}"
    Capybara.app_host = "http://#{domain}"
  end
end

def set_subdomain(subdomain)
  domain = "#{subdomain}.#{Setting[:base_domain].sub(/:\d+$/, '')}"
  set_domain(domain)
end

def set_subdomain_to_signup_subdomain
  set_domain(Setting[:signup_domain])
end

Given(/^the subdomain is "([^"]*)"$/) do |subdomain|
  set_subdomain(subdomain)
end

When(/^the domain is "([^"]*)"$/) do |domain|
  set_domain(domain)
end

When(/^I open the "(.*?)" tab$/) do |tab_name|
  within('.ui-tabs-nav') do
    click_link(tab_name)
  end
end

When(/^I click "(.*?)"$/) do |link|
  click_link(link)
end

Then(/^the domain should be "([^"]*)"$/) do |domain|
  current_domain = URI.parse(current_url).host
  current_domain.should == domain
end

Then(/^the subdomain should be "([^"]*)"$/) do |subdomain|
  current_subdomain = URI.parse(current_url).host.sub(".#{Setting[:base_domain].sub(/:\d+$/, '')}", '')
  current_subdomain.should == subdomain
end

Then(/^I should get a "(.*?)" download$/) do |extension|
  page.response_headers['Content-Disposition'].should =~ Regexp.new("filename=\".*\.#{Regexp.escape(extension)}\"")
end

Then(/^I should get a "([^"]*)" download with the name of the organisation$/) do |extension|
  @organisation ||= Organisation.last
  page.response_headers['Content-Disposition'].should =~ Regexp.new("filename=\"#{Regexp.escape(@organisation.name)}.*#{Regexp.escape(extension)}\"")
end

Then(/^I should not be able to press "([^"]*)"$/) do |button|
  expect(find_button(button, disabled: true)).to be_disabled
end
