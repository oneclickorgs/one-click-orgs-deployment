# encoding: UTF-8

Given /^members of the co\-op can hold more than one share$/ do
  @organisation.single_shareholding = false
  @organisation.save!
end

Given /^there is a member who has failed to attain the minimum shareholding after 12 months$/ do
  @organisation.minimum_shareholding = 3
  @organisation.save!

  @member = @organisation.members.make(:created_at => 13.months.ago, :inducted_at => 13.months.ago)
  @member.find_or_build_share_account.balance = 0
  @member.save!
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

Then /^I should see a notification that the member has failed to attain the minimum shareholding$/ do
  page.should have_content("#{@member.name} joined 13 months ago, but has failed to attain the minimum shareholding.")
end
