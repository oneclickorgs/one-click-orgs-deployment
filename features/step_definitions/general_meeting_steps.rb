Given /^there has been a past meeting$/ do
  @general_meeting = @organisation.general_meetings.make!(:past)
end

Given /^no minutes for the past meeting have been entered yet$/ do
  @general_meeting ||= @organisation.general_meetings.past.last

  @general_meeting.update_attribute(:minutes, nil)
end

When /^I follow "(.*?)" for the past meeting$/ do |link|
  @general_meeting ||= @organisation.general_meetings.past.last

  within("#general_meeting_#{@general_meeting.id}") do
    click_link(link)
  end
end

When /^I enter minutes for the meeting$/ do
  fill_in('general_meeting[minutes]', :with => "We discussed things.")
end

When /^I choose the Members who were in attendance$/ do
  members = @organisation.members.limit(2)
  members.each do |member|
    check(member.name)
  end
end

When /^I follow "(.*?)" for the meeting$/ do |link|
  @general_meeting ||= @organisation.general_meetings.last

  within("#general_meeting_#{@general_meeting.id}") do
    click_link(link)
  end
end

Then /^I should see the resolution in the list of resolutions to be considered at the meeting$/ do
  @resolution ||= @organisation.resolutions.last
  page.should have_css(".resolutions", :text => @resolution.title)
end

Then /^I should see "(.*?)" for the past meeting$/ do |text|
  @general_meeting ||= @organisation.general_meetings.past.last

  within("#general_meeting_#{@general_meeting.id}") do
    page.should have_content(text)
  end
end

Then /^I should see the minutes I entered$/ do
  page.should have_content("We discussed things.")
end

Then /^I should see the participants I chose$/ do
  members = @organisation.members.limit(2)

  within('.participants') do
    members.each do |member|
      page.should have_content(member.name)
    end
  end
end
