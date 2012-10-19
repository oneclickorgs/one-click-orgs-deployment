Given(/^the application is set up$/) do
  set_up_application
end

Given(/^the application is not set up yet$/) do
  step "the domain is \"www.example.com\""
end

When(/^the domain is the signup domain$/) do
  step %Q{the domain is "#{Setting[:signup_domain].sub(/:\d+$/, '')}"}
end
