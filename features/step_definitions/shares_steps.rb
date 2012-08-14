When /^I enter a new share value$/ do
  fill_in("New share value", :with => "0.70")
end

When /^I enter a new minimum shareholding$/ do
  fill_in("New minimum shareholding", :with => "3")
end

Then /^I should see the new share value$/ do
  page.should have_content("0.70")
end

Then /^I should see the new minimum shareholding$/ do
  page.should have_content("The minimum shareholding is 3 shares.")
end
