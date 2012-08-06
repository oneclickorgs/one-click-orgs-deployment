When /^I change the Name to "(.*?)"$/ do |name|
  fill_in('constitution_proposal_bundle[organisation_name]', :with => name)
end

When /^I change the Registered office address to "(.*?)"$/ do |address|
  fill_in('constitution_proposal_bundle[registered_office_address]', :with => address)
end

When /^I change the Objects to "(.*?)"$/ do |objects|
  fill_in('constitution_proposal_bundle[objectives]', :with => objects)
end

When /^I choose to allow "(.*?)" members$/ do |member_type|
  check("constitution_proposal_bundle[#{member_type.downcase}_members]")
end

When /^I choose to disallow "(.*?)" members$/ do |member_type|
  uncheck("constitution_proposal_bundle[#{member_type.downcase}_members]")
end

When /^I choose that Members hold one share only$/ do
  choose("constitution_proposal_bundle_single_shareholding_1")
end

When /^I enter "(.*?)" for each of the Board composition fields$/ do |number|
  %w{user employee supporter producer consumer}.each do |member_type|
    fill_in("constitution_proposal_bundle[max_#{member_type}_directors]", :with => number)
  end
end

When /^I choose Common Ownership$/ do
  choose("constitution_proposal_bundle_common_ownership_1")
end

Then /^I should see the rules of the co\-op$/ do
  page.should have_content("Industrial and Provident Societies Act 1965")
end
