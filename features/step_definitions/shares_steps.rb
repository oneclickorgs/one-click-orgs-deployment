When /^I enter a new share value$/ do
  fill_in("New share value", :with => "0.70")
end

Then /^I should see the new share value$/ do
  page.should have_content("0.70")
end
