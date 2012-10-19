Given(/^we have customised the Rules$/) do
  @organisation.objectives = "Change the world"
  @organisation.save!
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

Then(/^I should see the changes I made$/) do
  page.should have_content("The Tea Co-op")
  page.should have_content("1 Main Street")
  page.should have_content("buy all the tea.")
  page.should have_css("h3", :text => "User Members")
  page.should have_css("h3", :text => "Employee Members")
  page.should have_no_css("h3", :text => "Supporter Members")
  page.should have_no_css("h3", :text => "Producer Members")
  page.should have_no_css("h3", :text => "Consumer Members")
  page.should have_content("Members hold one nominal share only")
  page.should have_content("2 User Members")
  page.should have_content("2 Employee Members")
  page.should have_content("The Co-operative is a common ownership enterprise")
end

Then(/^I should see the rules of the co\-op$/) do
  page.should have_content("Industrial and Provident Societies Act 1965")
end

Then(/^I should see the customisations we have made to the rules$/) do
  page.should have_content("Change the world")
end
