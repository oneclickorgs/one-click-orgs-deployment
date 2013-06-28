include ActionView::Helpers::JavaScriptHelper

Given(/^there has been a past meeting$/) do
  @general_meeting = @organisation.general_meetings.make!(:past)
end

Given(/^no minutes for the past meeting have been entered yet$/) do
  @general_meeting ||= @organisation.general_meetings.past.last

  @general_meeting.update_attribute(:minutes, nil)
end

Given(/^there is an upcoming General Meeting$/) do
  @general_meeting = @meeting = @organisation.general_meetings.make!(:upcoming)
end

Given(/^there has been a General Meeting in the past$/) do
  @general_meeting = @meeting = @organisation.general_meetings.make!(:past)
end

Given(/^the resolutions were open for electronic voting$/) do
  unless @resolutions
    @meeting ||= @organisation.meetings.last
    @resolutions = @meeting.resolutions
  end

  @resolutions.each do |resolution|
    resolution.pause!
  end
end

When(/^I follow "(.*?)" for the past meeting$/) do |link|
  @general_meeting ||= @organisation.general_meetings.past.last

  within("#general_meeting_#{@general_meeting.id}") do
    click_link(link)
  end
end

When(/^I choose the Members who were in attendance$/) do
  members = @organisation.members.limit(2)
  within('div.participants') do
    members.each do |member|
      fill_in("Add member", :with => member.name)
      sleep(1)
      page.execute_script("$('.ui-menu-item a:contains(\"#{escape_javascript(member.name)}\")').trigger('mouseenter').click();")
    end
  end
end

When(/^I follow "(.*?)" for the meeting$/) do |link|
  @general_meeting ||= @organisation.general_meetings.last

  within("#general_meeting_#{@general_meeting.id}") do
    click_link(link)
  end
end

When(/^I select to open the resolution for electronic voting$/) do
  check("general_meeting[existing_resolutions_attributes][0][open]")
end

When(/^I enter a passing number of votes in favour for every resolution$/) do
  @meeting ||= @organisation.meetings.last
  @resolutions ||= @meeting.resolutions

  member_count = @organisation.members.count

  @resolutions.each do |resolution|
    within('#' + ActionController::RecordIdentifier.dom_id(resolution)) do
      fill_in("Votes for:", :with => member_count)
      fill_in("Votes against:", :with => 0)
    end
  end
end

Then(/^I should see the resolution in the list of resolutions to be considered at the meeting$/) do
  @resolution ||= @organisation.resolutions.last
  page.should have_css(".resolutions", :text => @resolution.title)
end

Then(/^I should see "(.*?)" for the past meeting$/) do |text|
  @general_meeting ||= @organisation.general_meetings.past.last

  within("#general_meeting_#{@general_meeting.id}") do
    page.should have_content(text)
  end
end

Then(/^I should see the minutes I entered$/) do
  if @minute_type && @minute_type == :agenda_items
    page.should have_content("Apologies for Absence")
    page.should have_content("Bob Smith")
    page.should have_content("Minutes of Previous Meeting")
    page.should have_content("The minutes of the previous meeting were accepted.")
    page.should have_content("Any Other Business")
    page.should have_content("Jenny Jenkins thanked Geoff Newell for providing the refreshments.")
    page.should have_content("Time and date of next meeting")
    page.should have_content("31 October at 6pm")
  else
    page.should have_content("We discussed things.")
  end
end

Then(/^I should see the participants I chose$/) do
  members = @organisation.members.limit(2)

  within('.participants') do
    members.each do |member|
      page.should have_content(member.name)
    end
  end
end
