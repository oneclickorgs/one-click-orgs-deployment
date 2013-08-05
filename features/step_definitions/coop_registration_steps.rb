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

When(/^I save the registration form$/) do
  click_button("Save changes")
end

Then(/^I should see that our registration has been submitted$/) do
  page.should have_content("has been submitted for registration")
end

Then(/^I should see that the registration form is done$/) do
  page.should have_content("The Registration Form has been filled in")
end
