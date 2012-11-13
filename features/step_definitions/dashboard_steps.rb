Then(/^I should see notifications of issues that require my attention$/) do
  page.should have_css('.tasks')
end

Then(/^I should see details of the upcoming general meeting$/) do
  @general_meeting ||= @organisation.general_meetings.upcoming.last

  page.should have_content("Next meeting")
  page.should have_content("General Meeting")
  page.should have_content(@general_meeting.start_time)
  page.should have_css("a[href='/general_meetings/#{@general_meeting.to_param}']")
end

Then(/^I should see that a proposal is open for voting$/) do
  @resolution ||= @organisation.proposals.last

  page.should have_content(@resolution.title)
  page.should have_css("input[data-url='/resolutions/#{@resolution.to_param}']")
end

Then(/^I should see a task in the Membership and Shares widget$/) do
  page.should have_css('.membership_and_shares ul.tasks')
end
