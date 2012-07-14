When /^I enter the text of the resolution$/ do
  fill_in("Text of the resolution", :with => "All new members should be required to introduce themselves at the next General Meeting.")
end

When /^I choose to allow electronic voting on the resolution$/ do
  choose "resolution_draft_false"
end

When /^I certify that the Board has decided to open this resolution$/ do
  check("resolution_certification")
end

Then /^I should see the new resolution in the list of currently\-open resolutions$/ do
  @resolution ||= @organisation.resolutions.last
  within('.proposals') do
    page.should have_content(@resolution.description)
  end
end
