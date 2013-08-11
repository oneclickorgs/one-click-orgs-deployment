require 'faker'

Given(/^the requirements for registration have been fulfilled$/) do
  @organisation.members.make!(3, :director)
  @organisation.members.make!(:secretary)

  @organisation.name ||= Faker::Company.name
  @organisation.registered_office_address ||= "#{Faker::Address.street_address}\n#{Faker::Address.city}\n#{Faker::Address.zip_code}"
  @organisation.objectives ||= Faker::Company.bs

  @organisation.signatories = @organisation.members.all[0..2]

  @organisation.save!
end

When(/^I submit the registration for our co\-op$/) do
  visit('/')
  click_button("Submit Co-op registration")
end

When(/^I choose three signatories$/) do
  @coop ||= Coop.pending.last

  signatories = @coop.founder_members.all[0..2]

  signatories.each do |signatory|
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

Then(/^I should see that our registration has been submitted$/) do
  page.should have_content("has been submitted for registration")
end

Then(/^I should see that the registration form is done$/) do
  page.should have_content("The Registration Form has been filled in")
end
