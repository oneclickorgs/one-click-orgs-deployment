require 'faker'

Given(/^the requirements for registration have been fulfilled$/) do
  @organisation.members.make!(3, :director)
  @organisation.members.make!(:secretary)

  @organisation.name ||= Faker::Company.name
  @organisation.registered_office_address ||= "#{Faker::Address.street_address}\n#{Faker::Address.city}\n#{Faker::Address.uk_postcode}"
  @organisation.objectives ||= Faker::Company.bs
  @organisation.reg_form_membership_required = true

  @organisation.save!
end

When(/^I submit the registration for our co\-op$/) do
  visit('/')
  click_button("Submit Co-op registration")
end

Then(/^I should see that our registration has been submitted$/) do
  page.should have_content("has been submitted for registration")
end
