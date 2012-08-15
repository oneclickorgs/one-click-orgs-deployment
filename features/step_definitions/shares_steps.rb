# encoding: UTF-8

Given /^members of the co\-op can hold more than one share$/ do
  @organisation.single_shareholding = false
  @organisation.save!
end

When /^I enter a new share value$/ do
  fill_in("New share value", :with => "0.70")
end

When /^I enter a new minimum shareholding$/ do
  fill_in("New minimum shareholding", :with => "3")
end

When /^I enter a new interest rate$/ do
  fill_in("New interest rate", :with => "1.34")
end

When /^I enter the number of additional shares I want$/ do
  fill_in('share_application[amount]', :with => '5')
end

Then /^I should see the new share value$/ do
  page.should have_content("0.70")
end

Then /^I should see the new minimum shareholding$/ do
  page.should have_content("The minimum shareholding is 3 shares.")
end

Then /^I should see the new interest rate$/ do
  page.should have_content("The rate of interest on share capital is 1.34%.")
end

Then /^I should see the payment that will be required$/ do
  page.should have_content("£5")
end

Then /^I should see that a payment is required for my new shares$/ do
  page.should have_content("A payment of £5 is due.")
end
