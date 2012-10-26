When(/^I enter "(.*?)" days$/) do |notice_period|
  fill_in('change_meeting_notice_period_resolution[meeting_notice_period]', :with => notice_period)
end

When(/^I certify that the Board has proposed this amendment$/) do
  if page.has_field?('change_meeting_notice_period_resolution[certification]')
    check('change_meeting_notice_period_resolution[certification]')
  else
    check('change_quorum_resolution[certification]')
  end
end

When(/^I certify that the resolution has already been passed$/) do
  if page.has_field?('change_meeting_notice_period_resolution[pass_immediately]')
    check('change_meeting_notice_period_resolution[pass_immediately]')
  else
    check('change_quorum_resolution[pass_immediately]')
  end
end

Then(/^I should see that the notice period is "(.*?)" days$/) do |notice_period|
  page.should have_content("The notice period for General Meetings is #{notice_period} clear days.")
end

Then(/^I should see that the quorum is (\d+) members or (\d+)% of the membership$/) do |number, percentage|
  page.should have_content("#{number} members and #{percentage}% of the membership")
end
