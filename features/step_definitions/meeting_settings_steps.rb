When(/^I enter "(.*?)" days$/) do |notice_period|
  fill_in('change_meeting_notice_period_resolution[meeting_notice_period]', :with => notice_period)
end
