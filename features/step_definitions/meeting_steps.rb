require 'action_controller/record_identifier'

def select_meeting_date
  meeting_date = 1.month.from_now

  if page.has_field?('general_meeting[happened_on(1i)]')
    select(meeting_date.year.to_s, :from => 'general_meeting[happened_on(1i)]')
    select(meeting_date.strftime('%B'), :from => 'general_meeting[happened_on(2i)]')
    select(meeting_date.day.to_s, :from => 'general_meeting[happened_on(3i)]')
  else
    select(meeting_date.year.to_s, :from => 'board_meeting[happened_on(1i)]')
    select(meeting_date.strftime('%B'), :from => 'board_meeting[happened_on(2i)]')
    select(meeting_date.day.to_s, :from => 'board_meeting[happened_on(3i)]')
  end
end

def fill_in_start_time
  if page.has_field?('general_meeting[start_time]')
    fill_in('general_meeting[start_time]', :with => '4pm')
  else
    fill_in('board_meeting[start_time]', :with => '4pm')
  end
end

def fill_in_venue
  if page.has_field?('general_meeting[venue]')
    fill_in('general_meeting[venue]', :with => "The Meeting Hall")
  else
    fill_in('board_meeting[venue]', :with => "The Meeting Hall")
  end
end

def fill_in_agenda
  if page.has_field?('general_meeting[agenda]')
    fill_in('general_meeting[agenda]', :with => "Discuss things. AOB.")
  else
    fill_in('board_meeting[agenda]', :with => "Discuss things. AOB.")
  end
end

def check_certification
  check('general_meeting[certification]')
end

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
  select_meeting_date
end

When /^I enter a start time for the meeting$/ do
  fill_in_start_time
end

When /^I enter a venue for the meeting$/ do
  fill_in_venue
end

When /^I enter an agenda for the meeting$/ do
  fill_in_agenda
end

When /^I enter the business to be transacted during the meeting$/ do
  fill_in_agenda
end

When /^I certify that the Board has decided to convene the meeting$/ do
  check_certification
end

When /^I check the certification$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I enter "(.*?)" for the new notice period$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I convene a General Meeting$/ do
  visit(new_general_meeting_path)
  select_meeting_date
  fill_in_start_time
  fill_in_venue
  fill_in_agenda
  check_certification
  click_button("Confirm and convene the meeting")
end

When /^I enter details for the meeting$/ do
  select_meeting_date
  fill_in_start_time
  fill_in_venue
  fill_in_agenda
  check_certification
end

When /^I select one of the draft resolutions to be considered at the meeting$/ do
  draft_resolutions = @organisation.resolutions.draft
  check("general_meeting[existing_resolutions_attributes][0][attached]")
end

When /^I convene the meeting$/ do
  click_button("Confirm and convene the meeting")
end

Then /^the meeting should have the draft resolution I selected attached to its agenda$/ do
  # We selected the first draft resolution on the form
  @resolution ||= @organisation.resolutions.draft.first
  @meeting ||= @organisation.meetings.last

  @meeting.resolutions.should include(@resolution)
end

Then /^I should see the meeting details I chose in the list of Upcoming Meetings$/ do
  within('.upcoming_meetings') do
    page.should have_content("Board Meeting")
    page.should have_content("4pm")
    page.should have_content("The Meeting Hall")
  end
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

Then /^I should see a list of the Directors who are due for retirement$/ do
  # As this is the first AGM, all of the current Directors must stand down.
  within('.directors') do
    @organisation.directors.each do |director|
      page.should have_content(director.name)
    end
  end
end

Then /^I should see the new AGM in the list of Upcoming Meetings$/ do
  within('.upcoming_meetings') do
    page.should have_content("Annual General Meeting")
  end
end
