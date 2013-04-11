require 'action_controller/record_identifier'

Given(/^there has been a past AGM$/) do
  @annual_general_meeting = @organisation.annual_general_meetings.make!(:past)
end

Given(/^no minutes for the past AGM have been entered yet$/) do
  @annual_general_meeting ||= @organisation.annual_general_meetings.past.last

  @annual_general_meeting.update_attribute(:minutes, nil)
end

Given(/^the AGM has no minutes yet$/) do
  @annual_general_meeting ||= @organisation.annual_general_meetings.past.last

  @annual_general_meeting.update_attribute(:minutes, nil)
end

Given(/^there were resolutions attached to the AGM$/) do
  @resolutions = @organisation.resolutions.make!(2)

  @annual_general_meeting ||= @organisation.annual_general_meetings.last

  @annual_general_meeting.resolutions << @resolutions
end

When(/^I follow "(.*?)" for the past AGM$/) do |link|
  @annual_general_meeting ||= @organisation.annual_general_meetings.past.last

  within("#annual_general_meeting_#{@annual_general_meeting.id}") do
    click_link(link)
  end
end

When(/^I enter minutes for the AGM$/) do
  enter_minutes
end

When(/^I follow "(.*?)" for the AGM$/) do |link|
  @annual_general_meeting ||= @organisation.annual_general_meetings.last

  within("#annual_general_meeting_#{@annual_general_meeting.id}") do
    click_link(link)
  end
end

Then(/^I should see "(.*?)" for the past AGM$/) do |content|
  @annual_general_meeting ||= @organisation.annual_general_meetings.past.last

  within("#annual_general_meeting_#{@annual_general_meeting.id}") do
    page.should have_content(content)
  end
end

Then(/^I should see the AGM in the list of Past Meetings$/) do
  @annual_general_meeting ||= @organisation.annual_general_meetings.last
  within('.past_meetings') do
    page.should have_css('#' + ActionController::RecordIdentifier.dom_id(@annual_general_meeting))
  end
end
