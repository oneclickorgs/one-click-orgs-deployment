# encoding: UTF-8

Given(/^members of the co\-op can hold more than one share$/) do
  @organisation.single_shareholding = false
  @organisation.save!
end

Given(/^there is a member who has failed to attain the minimum shareholding after 12 months$/) do
  @organisation.minimum_shareholding = 3
  @organisation.save!

  @member = @organisation.members.make(:created_at => 13.months.ago, :inducted_at => 13.months.ago)
  @member.find_or_build_share_account.balance = 0
  @member.save!
end

Given(/^a member has made an application for more shares$/) do
  @member = @organisation.members.make!

  @original_balance = @member.find_or_build_share_account.balance

  @share_application = ShareApplication.new(:amount => 3)
  @share_application.member = @member
  @share_application.save!
end

Given(/^a member's share withdrawal application has fallen due$/) do
  @member = @organisation.members.make!
  @original_balance = @member.find_or_build_share_account.balance
  @share_withdrawal = ShareWithdrawal.new(:amount => 1)
  @share_withdrawal.member = @member
  @share_withdrawal.save!
  @share_withdrawal.share_transaction.update_attribute(:created_at, (3.months + 1.day).ago)
end

When(/^I enter a new share value$/) do
  fill_in("New share value", :with => "0.70")
end

When(/^I enter a new minimum shareholding$/) do
  fill_in("New minimum shareholding", :with => "3")
end

When(/^I enter a new interest rate$/) do
  fill_in("New interest rate", :with => "1.34")
end

When(/^I enter the number of additional shares I want$/) do
  fill_in('share_application[amount]', :with => '5')
end

When(/^the share transaction daily job runs$/) do
  ShareTransaction.run_daily_job
end

Then(/^I should see the new share value$/) do
  page.should have_content("0.70")
end

Then(/^I should see the new minimum shareholding$/) do
  page.should have_content("The minimum shareholding is 3 shares.")
end

Then(/^I should see the new interest rate$/) do
  page.should have_content("The rate of interest on share capital is 1.34%.")
end

Then(/^I should see the payment that will be required$/) do
  page.should have_content("£5")
end

Then(/^I should see that a payment is required for my new shares$/) do
  page.should have_content("A payment of £5 is due.")
end

Then(/^I should see a notification that the member has failed to attain the minimum shareholding$/) do
  page.should have_content("#{@member.name} joined 13 months ago, but has failed to attain the minimum shareholding.")
end

Then(/^I should see the share application$/) do
  page.should have_content("applied for 3 shares")
end

Then(/^I should see that the member's new shares have been allotted$/) do
  expected_share_balance = @original_balance + 3
  within("#member_#{@member.id}") do
    page.should have_content(@member.name)
    page.should have_content(expected_share_balance)
  end
end

Then(/^I should see that a share withdrawal application is now due$/) do
  page.should have_content("The withdrawal is now due.")
end

Then(/^I should see that the member's shareholding has reduced accordingly$/) do
  expected_share_balance = @original_balance - 1
  within("#member_#{@member.id}") do
    page.should have_content(@member.name)
    page.should have_content(expected_share_balance)
  end
end
