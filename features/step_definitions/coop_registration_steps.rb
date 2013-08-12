require 'faker'

Given(/^the requirements for registration have been fulfilled$/) do
  @organisation.members.make!(3, :director)
  @organisation.members.make!(:secretary)

  @organisation.name ||= Faker::Company.name
  @organisation.registered_office_address ||= "#{Faker::Address.street_address}\n#{Faker::Address.city}\n#{Faker::Address.zip_code}"
  @organisation.objectives ||= Faker::Company.bs

  @organisation.signatories = @organisation.members.all[0..2]

  @organisation.reg_form_main_contact_name = "Bob Smith"
  @organisation.reg_form_main_contact_address = "1 Main Street\nLondon\nN1 1AA"
  @organisation.reg_form_main_contact_phone = "01234 567 890"
  @organisation.reg_form_main_contact_email = "bob@example.com"

  @organisation.reg_form_money_laundering_0_name = "Bob Smith"
  @organisation.reg_form_money_laundering_0_date_of_birth = "1 January 1970"
  @organisation.reg_form_money_laundering_0_address = "1 Main Street"
  @organisation.reg_form_money_laundering_0_postcode = "N1 1AA"
  @organisation.reg_form_money_laundering_0_residency_length = "6 years"

  @organisation.reg_form_money_laundering_1_name = "Jane Baker"
  @organisation.reg_form_money_laundering_1_date_of_birth = "1 May 1980"
  @organisation.reg_form_money_laundering_1_address = "40 High Street"
  @organisation.reg_form_money_laundering_1_postcode = "SW1 1AA"
  @organisation.reg_form_money_laundering_1_residency_length = "15 years"

  @organisation.reg_form_money_laundering_agreement = true

  @organisation.save!
end

Given(/^the money laundering form has been filled in$/) do
  @organisation ||= Coop.pending.last

  @organisation.reg_form_main_contact_name = "Bob Smith"
  @organisation.reg_form_main_contact_address = "1 Main Street\nLondon\nN1 1AA"
  @organisation.reg_form_main_contact_phone = "01234 567 890"
  @organisation.reg_form_main_contact_email = "bob@example.com"

  @organisation.reg_form_money_laundering_0_name = "Bob Smith"
  @organisation.reg_form_money_laundering_0_date_of_birth = "1 January 1970"
  @organisation.reg_form_money_laundering_0_address = "1 Main Street"
  @organisation.reg_form_money_laundering_0_postcode = "N1 1AA"
  @organisation.reg_form_money_laundering_0_residency_length = "6 years"

  @organisation.reg_form_money_laundering_1_name = "Jane Baker"
  @organisation.reg_form_money_laundering_1_date_of_birth = "1 May 1980"
  @organisation.reg_form_money_laundering_1_address = "40 High Street"
  @organisation.reg_form_money_laundering_1_postcode = "SW1 1AA"
  @organisation.reg_form_money_laundering_1_residency_length = "15 years"

  @organisation.reg_form_money_laundering_agreement = true

  @organisation.save!
end

When(/^I submit the registration for our co\-op$/) do
  visit('/')
  click_button("Submit Co-op registration")
end

When(/^I choose three signatories$/) do
  @coop ||= Coop.pending.last

  @signatories = @coop.founder_members.all[0..2]

  @signatories.each do |signatory|
    check(signatory.name)
  end
end

When(/^I enter the main contact info$/) do
  fill_in('registration_form[reg_form_main_contact_organisation_name]', :with => "Acme Ltd")
  fill_in('registration_form[reg_form_main_contact_name]', :with => "Bob Smith")
  fill_in('registration_form[reg_form_main_contact_address]', :with => "1 Main Street\nLondon\nN1 1AA")
  fill_in('registration_form[reg_form_main_contact_phone]', :with => '01234 567 890')
  fill_in('registration_form[reg_form_main_contact_email]', :with => 'bob@example.com')
end

When(/^I enter the financial contact info$/) do
  fill_in('registration_form[reg_form_financial_contact_name]', :with => "Jane Baker")
  fill_in('registration_form[reg_form_financial_contact_phone]', :with => '020 7777 7777')
  fill_in('registration_form[reg_form_financial_contact_email]', :with => 'jane@example.com')
end

When(/^I enter details for the two money laundering contacts$/) do
  fill_in('registration_form[reg_form_money_laundering_0_name]', :with => "Bob Smith")
  fill_in('registration_form[reg_form_money_laundering_0_date_of_birth]', :with => "1 January 1970")
  fill_in('registration_form[reg_form_money_laundering_0_address]', :with => "1 Main Street")
  fill_in('registration_form[reg_form_money_laundering_0_postcode]', :with => "N1 1AA")
  fill_in('registration_form[reg_form_money_laundering_0_residency_length]', :with => "6 years")

  fill_in('registration_form[reg_form_money_laundering_1_name]', :with => "Jane Baker")
  fill_in('registration_form[reg_form_money_laundering_1_date_of_birth]', :with => "1 May 1980")
  fill_in('registration_form[reg_form_money_laundering_1_address]', :with => "40 High Street")
  fill_in('registration_form[reg_form_money_laundering_1_postcode]', :with => "SW1 1AA")
  fill_in('registration_form[reg_form_money_laundering_1_residency_length]', :with => "15 years")
end

When(/^I save the registration (?:form|details)$/) do
  click_button("Save changes")
end

Then(/^I should see the main contact info$/) do
  expect(find_field('registration_form[reg_form_main_contact_organisation_name]').value).to eq("Acme Ltd")
  expect(find_field('registration_form[reg_form_main_contact_name]').value).to eq("Bob Smith")
  expect(find_field('registration_form[reg_form_main_contact_address]').value).to eq("1 Main Street\nLondon\nN1 1AA")
  expect(find_field('registration_form[reg_form_main_contact_phone]').value).to eq("01234 567 890")
  expect(find_field('registration_form[reg_form_main_contact_email]').value).to eq("bob@example.com")
end

Then(/^I should see the financial contact info$/) do
  expect(find_field('registration_form[reg_form_financial_contact_name]').value).to eq("Jane Baker")
  expect(find_field('registration_form[reg_form_financial_contact_phone]').value).to eq("020 7777 7777")
  expect(find_field('registration_form[reg_form_financial_contact_email]').value).to eq("jane@example.com")
end

Then(/^I should see the details for the two money laundering contacts$/) do
  expect(find_field('registration_form[reg_form_money_laundering_0_name]').value).to eq("Bob Smith")
  expect(find_field('registration_form[reg_form_money_laundering_0_date_of_birth]').value).to eq("1 January 1970")
  expect(find_field('registration_form[reg_form_money_laundering_0_address]').value).to eq("1 Main Street")
  expect(find_field('registration_form[reg_form_money_laundering_0_postcode]').value).to eq("N1 1AA")
  expect(find_field('registration_form[reg_form_money_laundering_0_residency_length]').value).to eq("6 years")

  expect(find_field('registration_form[reg_form_money_laundering_1_name]').value).to eq("Jane Baker")
  expect(find_field('registration_form[reg_form_money_laundering_1_date_of_birth]').value).to eq("1 May 1980")
  expect(find_field('registration_form[reg_form_money_laundering_1_address]').value).to eq("40 High Street")
  expect(find_field('registration_form[reg_form_money_laundering_1_postcode]').value).to eq("SW1 1AA")
  expect(find_field('registration_form[reg_form_money_laundering_1_residency_length]').value).to eq("15 years")
end

Then(/^I should see the agreement checkbox is checked$/) do
  page.should have_css("input[name='registration_form[reg_form_money_laundering_agreement]'][checked=checked]")
end

Then(/^I should see that our registration has been submitted$/) do
  page.should have_content("has been submitted for registration")
end

Then(/^I should see that the registration form is done$/) do
  page.should have_content("The Registration Form has been filled in")
end

Then(/^I should see the three signatories I chose$/) do
  @signatories ||= @coop.founder_members.all[0..2]

  @signatories.each do |signatory|
    expect(find_field(signatory.name)['checked']).to be_true
  end
end
