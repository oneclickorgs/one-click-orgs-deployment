# encoding: UTF-8

require 'rticles'

Given(/^we have customised the Rules$/) do
  @organisation.objectives = "Change the world"
  @organisation.save!
end

Given(/^the objects were changed (\d+) months ago$/) do |months_ago|
  months_ago = months_ago.to_i
  @organisation.objectives = Faker::Lorem.sentence
  @organisation.save!
  @organisation.clauses.get_current(:organisation_objectives).update_attribute(:started_at, months_ago.months.ago)
end

Given(/^there is an alternative model Rules document$/) do
  File.open(File.join(Rails.root, 'spec', 'fixtures', 'alternative_rules.yml'), 'r') do |alternative_document_file|
    alternative_document = Rticles::Document.from_yaml(alternative_document_file)
    expect(alternative_document).to be_persisted
    alternative_document.update_attribute(:title, 'alternative_rules')
  end
end

Given(/^the Coop "(.*?)" is set to use the alternative model Rules document$/) do |name|
  coop = Coop.find_by_name(name)
  coop.constitution.document_template = Rticles::Document.find_by_title('alternative_rules')
  coop.save!
end

When(/^I change the Name to "(.*?)"$/) do |name|
  fill_in('change_name_resolution[organisation_name]', :with => name)
end

When(/^I change the Registered office address to "(.*?)"$/) do |address|
  fill_in('change_registered_office_address_resolution[registered_office_address]', :with => address)
end

When(/^I change the Objects to "(.*?)"$/) do |objects|
  fill_in('change_objectives_resolution[objectives]', :with => objects)
end

When(/^I choose to allow "(.*?)" members$/) do |member_type|
  check("change_membership_criteria_resolution[#{member_type.downcase}_members]")
end

When(/^I choose to disallow "(.*?)" members$/) do |member_type|
  uncheck("change_membership_criteria_resolution[#{member_type.downcase}_members]")
end

When(/^I choose that Members hold one share only$/) do
  choose("change_single_shareholding_resolution_single_shareholding_1")
end

When(/^I enter "(.*?)" for each of the Board composition fields$/) do |number|
  %w{user employee supporter producer consumer}.each do |member_type|
    fill_in("change_board_composition_resolution[max_#{member_type}_directors]", :with => number)
  end
end

When(/^I choose Common Ownership$/) do
  choose("change_common_ownership_resolution_common_ownership_1")
end

When(/^I make changes to the rules$/) do
  fill_in('constitution[organisation_name]', :with => "The Tea Co-op")
  fill_in('constitution[registered_office_address]', :with => "1 Main Street")
  fill_in('constitution[objectives]', :with => "buy all the tea.")
  check("constitution[user_members]")
  check("constitution[employee_members]")
  uncheck("constitution[supporter_members]")
  uncheck("constitution[producer_members]")
  uncheck("constitution[consumer_members]")
  choose("constitution_single_shareholding_1")
  %w{user employee supporter producer consumer}.each do |member_type|
    fill_in("constitution[max_#{member_type}_directors]", :with => '2')
  end
  choose("constitution_common_ownership_1")
end

When(/^I save the changes$/) do
  click_button("Save changes")
end

When(/^the Coop is set to use the alternative model Rules document$/) do
  @coop.constitution.document_template = Rticles::Document.find_by_title('alternative_rules')
  @coop.save!
end

Then(/^I should see the changes I made$/) do
  page.should have_content("The Tea Co-op")
  page.should have_content("1 Main Street")
  page.should have_content("buy all the tea.")
  page.should have_css("h3", :text => "User Members")
  page.should have_css("h3", :text => "Employee Members")
  page.should have_no_css("h3", :text => "Supporter Members")
  page.should have_no_css("h3", :text => "Producer Members")
  page.should have_no_css("h3", :text => "Consumer Members")
  page.should have_content("Each Member shall hold one share only")
  page.should have_content("2 User Members")
  page.should have_content("2 Employee Members")
  page.should have_content("is a common ownership enterprise")
end

Then(/^I should see the rules of the co\-op$/) do
  page.should have_content("Industrial and Provident Societies Act 1965")
end

Then(/^I should see the customisations we have made to the rules$/) do
  page.should have_content("Change the world")
end

Then(/^I should see the custom fields in the Rules filled in appropriately$/) do
  constitution = @organisation.constitution

  # TODO Check the custom fields which result in entire sections of the
  # Rules being displayed or not; not just the custom fields which are
  # displayed literally in the Rules.

  # TODO Do a more precise check of the appearance of fields like
  # 'max_user_directors' which are just a number. Such a number probably
  # will occur somewhere else in the Rules, and hence trigger a false positive
  # in this test.

  [
    :name,
    :registered_office_address,
    :objectives,
    :meeting_notice_period,
    :quorum_number,
    :quorum_percentage,
    :max_user_directors,
    :max_employee_directors,
    :max_supporter_directors,
    :max_producer_directors,
    :max_consumer_directors
  ].each do |field|
    page.should have_content(constitution.send(field))
  end
end

Then(/^I should see that the Rules were last changed (\d+) months ago$/) do |months_ago|
  months_ago = months_ago.to_i
  expect(page).to have_content("last changed on #{months_ago.months.ago.to_s(:long_date)}")
end

Then(/^I should see the alternative Rules$/) do
  expect(page).to have_content('These are the alternative rules.')
end

Then(/^I should see the default Rules$/) do
  expect(page).to have_content('The purpose of the Co‑operative is to carry out its function as a Co‑operative')
end
