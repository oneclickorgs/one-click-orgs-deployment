Given /^the subdomain is "([^"]*)"$/ do |subdomain|
  When %Q{the domain is "#{subdomain}.#{Setting[:base_domain].sub(/:\d+$/, '')}"}
end

When /^the domain is "([^"]*)"$/ do |domain|
  Capybara.default_host = domain
  if Capybara.current_driver == :selenium
    Capybara.app_host = "http://#{domain}:#{Capybara.server_port}"
  end
end

Then /^the domain should be "([^"]*)"$/ do |domain|
  current_domain = URI.parse(current_url).host
  current_domain.should == domain
end

Then /^the subdomain should be "([^"]*)"$/ do |subdomain|
  current_subdomain = URI.parse(current_url).host.sub(".#{Setting[:base_domain].sub(/:\d+$/, '')}", '')
  current_subdomain.should == subdomain
end

Then /^I should get a download with the filename "([^\"]*)"$/ do |filename|
  page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
end
