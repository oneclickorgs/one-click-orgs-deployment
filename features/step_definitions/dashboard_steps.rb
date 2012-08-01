Then /^I should see notifications of issues that require my attention$/ do
  page.should have_css('ul.tasks')
end

Then /^I should see action buttons for things I commonly want to do$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a timeline of recent events in the co\-op$/ do
  page.should have_css('table.timeline td')
end

