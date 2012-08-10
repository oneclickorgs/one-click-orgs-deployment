When /^I submit the registration for our co\-op$/ do
  visit('/')
  click_button("Submit Co-op registration")
end

Then /^I should see that our registration has been submitted$/ do
  page.should have_content("has been submitted for registration")
end
