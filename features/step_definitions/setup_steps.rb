def fill_administrator_setup_form
  fill_in('Email', with: 'admin@example.com')
  fill_in('Choose a password', with: 'password')
  fill_in('Confirm password', with: 'password')
end

Given(/^the application is set up$/) do
  set_up_application
end

Given(/^the application is not set up yet$/) do
  step "the domain is \"www.example.com\""
end

Given(/^I have chosen and saved the domains$/) do
  visit('/setup/domains')
  fill_in('base domain', with: 'example.com')
  fill_in('sign-up domain', with: 'create.example.com')
  click_button('Save domains')
end

Given(/^I have set up an administrator account$/) do
  visit('/setup/administrator')
  fill_administrator_setup_form
  click_button('Save administrator account')
end

When(/^I have choose and save the domains$/) do
  visit('/setup/domains')
  fill_in('base domain', with: 'example.com')
  fill_in('sign-up domain', with: 'create.example.com')
  click_button('Save domains')
end

When(/^I choose and save the organisation types$/) do
  check('Associations')
  check('Companies Limited by Guarantee')
  check('Co-operatives')
  click_button('Save settings')
end

When(/^I choose the organisation types$/) do
  check('Associations')
  check('Companies Limited by Guarantee')
  check('Co-operatives')
end

When(/^the domain is the signup domain$/) do
  step %Q{the domain is "#{Setting[:signup_domain].sub(/:\d+$/, '')}"}
end

When(/^I choose "(.*?)" and "(.*?)" from the organisation types$/) do |organisation_type_1, organisation_type_2|
  check(organisation_type_1)
  check(organisation_type_2)
end

When(/^I do not choose "(.*?)" from the organisation types$/) do |organisation_type|
  uncheck(organisation_type)
end

When(/^I choose the domains for the installation$/) do
  fill_in('base domain', with: 'example.com')
  fill_in('sign-up domain', with: 'create.example.com')
end

When(/^I submit the organisation types form$/) do
  click_button('Save settings')
end

When(/^I enter an email and password for the new administrator account$/) do
  fill_administrator_setup_form
end

When(/^I save the new administrator account$/) do
  click_button('Save administrator account')
end

When(/^I set up an administrator account$/) do
  visit('/setup/administrator')
  fill_administrator_setup_form
  click_button('Save administrator account')
end

When(/^I choose and save the domains$/) do
  visit('/setup/domains')
  fill_in('base domain', with: 'example.com')
  fill_in('sign-up domain', with: 'create.example.com')
  click_button('Save domains')
end

Then(/^I should see a link to make a new association$/) do
  page.should have_css("a[href='/associations/new']")
end

Then(/^I should see a link to make a new company$/) do
  page.should have_css("a[href='/companies/new']")
end

Then(/^I should not see a link to make a new co\-operative$/) do
  page.should_not have_css("a[href='/coops/new']")
end

Then(/^there should be an administrator$/) do
  expect(Administrator.any?).to be true
end
