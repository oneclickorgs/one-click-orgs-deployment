require 'action_controller/record_identifier'

Given /^another director has recorded some minutes$/ do
  @company ||= Company.last
  @meeting = @company.meetings.make!
end

Given /^another director has recorded some new minutes$/ do
  step "another director has recorded some minutes"
end

Given /^the notice period for General Meetings is "(.*?)" days$/ do |arg1|
  @organisation.constitution.meeting_notice_period = 14
end

When /^I choose the date of discussion$/ do
  select('2011', :from => 'meeting[happened_on(1i)]')
  select('May', :from => 'meeting[happened_on(2i)]')
  select('1', :from => 'meeting[happened_on(3i)]')
end

When /^I check the first two directors' checkboxes$/ do
  @company ||= Company.last
  directors = @company.members.where(
    :member_class_id => @company.member_classes.find_by_name('Director').id
  ).limit(2).order('id ASC')
  directors.each do |director|
    check(director.name)
  end
end

When /^I choose a date for the meeting$/ do
  meeting_date = 1.month.from_now
  select(meeting_date.year.to_s, :from => 'general_meeting[happened_on(1i)]')
  select(meeting_date.strftime('%B'), :from => 'general_meeting[happened_on(2i)]')
  select(meeting_date.day.to_s, :from => 'general_meeting[happened_on(3i)]')
end

When /^I enter a start time for the meeting$/ do
  fill_in('general_meeting[start_time]', :with => '4pm')
end

When /^I enter a venue for the meeting$/ do
  fill_in('general_meeting[venue]', :with => "The Meeting Hall")
end

When /^I enter an agenda for the meeting$/ do
  fill_in('general_meeting[agenda]', :with => "Discuss things. AOB.")
end

When /^I certify that the Board has decided to convene the meeting$/ do
  check('general_meeting[certification]')
end

When /^I check the certification$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I enter "(.*?)" for the new notice period$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a form for recording minutes$/ do
  form_selector = "form[action='/meetings']"
  
  page.should have_css(form_selector)
  
  page.should have_css("#{form_selector} select[name='meeting[happened_on(1i)]']")
  page.should have_css("#{form_selector} select[name='meeting[happened_on(2i)]']")
  page.should have_css("#{form_selector} select[name='meeting[happened_on(3i)]']")
  
  page.should have_css("#{form_selector} textarea[name='meeting[minutes]']")
end

Then /^I should see a checkbox for each director$/ do
  @company ||= Company.last
  directors = @company.members.where(
    :member_class_id => @company.member_classes.find_by_name('Director').id
  )
  directors.each do |director|
    page.should have_css("input[type='checkbox'][name='meeting[participant_ids][#{director.id}]']")
  end
end

Then /^I should see the minutes for "([^"]*)" in the timeline$/ do |minutes|
  with_scope("the timeline") do
    page.should have_css("td", :text => minutes)
  end
end

Then /^I should see the first two directors' names as participants$/ do
  @company ||= Company.last
  directors = @company.members.where(
    :member_class_id => @company.member_classes.find_by_name('Director').id
  ).limit(2).order('id ASC')
  directors.each do |director|
    page.should have_selector('ul.participants li', :text => director.name)
  end
end

Then /^I should see the minutes$/ do
  @meeting ||= Meeting.last
  
  @meeting.participants.each do |participant|
    page.should have_selector('ul.participants li', :text => participant.name)
  end
  
  page.should have_content(@meeting.minutes)
  
  page.should have_content(@meeting.happened_on.to_s(:long_ordinal))
end

Then /^I should see the new meeting in the list of Upcoming Meetings$/ do
  @meeting ||= @organisation.meetings.last

  within('.upcoming_meetings') do
    page.should have_css('#' + ActionController::RecordIdentifier.dom_id(@meeting))
  end
end

Then /^all the Members should receive a notification of the new meeting$/ do
  pending # express the regexp above with the code you wish you had
end

