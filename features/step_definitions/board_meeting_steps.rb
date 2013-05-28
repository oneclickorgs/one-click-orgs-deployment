Given(/^there has been a past board meeting$/) do
  @meeting = @board_meeting ||= @organisation.board_meetings.make!(:past)
end

Given(/^no minutes for the past board meeting have been entered yet$/) do
  @board_meeting ||= @organisation.board_meetings.past.last
  @board_meeting.update_attribute(:minutes, nil)
end

When(/^I enter minutes for the board meeting$/) do
  enter_minutes
end

When(/^I follow "(.*?)" for the past board meeting$/) do |link|
  @board_meeting ||= @organisation.board_meetings.past.last

  within("#board_meeting_#{@board_meeting.id}") do
    click_link(link)
  end
end

When(/^I choose the Directors who were in attendance$/) do
  directors = @organisation.directors
  directors.each do |director|
    check(director.name)
  end
end

When(/^I follow "(.*?)" for the board meeting$/) do |link|
  @board_meeting ||= @organisation.board_meetings.last

  within("#board_meeting_#{@board_meeting.id}") do
    click_link(link)
  end
end

Then(/^I should see "(.*?)" for the past board meeting$/) do |text|
  @board_meeting ||= @organisation.board_meetings.past.last

  within("#board_meeting_#{@board_meeting.id}") do
    page.should have_content(text)
  end
end
