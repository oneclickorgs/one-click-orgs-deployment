require 'action_controller/record_identifier'

def select_meeting_date
  meeting_date = 1.month.from_now

  if page.has_css?('#general_meeting_happened_on_datepicker')
    page.execute_script(%Q{$('#general_meeting_happened_on_datepicker').datepicker('setDate', new Date(#{meeting_date.year}, #{meeting_date.month}, #{meeting_date.day}));})
  elsif page.has_css?('#annual_general_meeting_happened_on_datepicker')
    page.execute_script(%Q{$('#annual_general_meeting_happened_on_datepicker').datepicker('setDate', new Date(#{meeting_date.year}, #{meeting_date.month}, #{meeting_date.day}));})
  elsif page.has_css?('#board_meeting_happened_on_datepicker')
    page.execute_script(%Q{$('#board_meeting_happened_on_datepicker').datepicker('setDate', new Date(#{meeting_date.year}, #{meeting_date.month}, #{meeting_date.day}));})
  else
    raise "Could not find meeting date field"
  end
end

def fill_in_start_time
  if page.has_field?('general_meeting[start_time]')
    fill_in('general_meeting[start_time]', :with => '4pm')
  else
    fill_in('board_meeting[start_time]', :with => '4pm')
  end
end

def select_start_time
  if page.has_css?('#general_meeting_start_time_proxy_4i')
    select("16", :from => 'general_meeting[start_time_proxy(4i)]')
    select("00", :from => 'general_meeting[start_time_proxy(5i)]')
  else
    select("16", :from => 'annual_general_meeting[start_time_proxy(4i)]')
    select("00", :from => 'annual_general_meeting[start_time_proxy(5i)]')
  end
end

def fill_in_venue
  if page.has_field?('general_meeting[venue]')
    fill_in('general_meeting[venue]', :with => "The Meeting Hall")
  elsif page.has_field?('annual_general_meeting[venue]')
    fill_in('annual_general_meeting[venue]', :with => "The Meeting Hall")
  else
    fill_in('board_meeting[venue]', :with => "The Meeting Hall")
  end
end

def fill_in_agenda
  if page.has_field?('general_meeting[agenda]')
    fill_in('general_meeting[agenda]', :with => "Discuss things. AOB.")
  elsif page.has_field?('annual_general_meeting[agenda]')
    fill_in('annual_general_meeting[agenda]', :with => "Discuss things. AOB.")
  else
    fill_in('board_meeting[agenda]', :with => "Discuss things. AOB.")
  end
end

def check_certification
  check('general_meeting[certification]')
end

def enter_minutes
  if page.has_field?('Apologies for Absence')
    fill_in("Apologies for Absence", :with => "Bob Smith")
    fill_in("Minutes of Previous Meeting", :with => "The minutes of the previous meeting were accepted.")
    if page.has_field?('Election of Directors')
      fill_in('Election of Directors', :with => "Gabriella Johnson and Sandy Newman were elected to the Board of Directors")
    end
    fill_in("Any Other Business", :with => "Jenny Jenkins thanked Geoff Newell for providing the refreshments.")
    fill_in("Time and date of next meeting", :with => "31 October at 6pm")
    @minute_type = :agenda_items
  elsif page.has_field?('minute[minutes]')
    fill_in('minute[minutes]', :with => "We discussed things.")
    @minute_type = :minutes
  elsif page.has_field?('board_meeting[minutes]')
    fill_in('board_meeting[minutes]', :with => "We discussed things.")
    @minute_type = :minutes
  else
    raise "Could not find minutes field."
  end
end

Given(/^another director has recorded some minutes$/) do
  @company ||= Company.last
  @meeting = @company.meetings.make!
end

Given(/^another director has recorded some new minutes$/) do
  step "another director has recorded some minutes"
end

Given(/^the notice period for General Meetings is "(.*?)" days$/) do |arg1|
  @organisation.constitution.meeting_notice_period = 14
end

Given(/^the meeting has no minutes yet$/) do
  @meeting ||= @organisation.meetings.last
  @meeting.update_attribute(:minutes, nil)
end

Given(/^there were resolutions attached to the meeting$/) do
  @resolutions = @organisation.resolutions.make!(2)
  @meeting ||= @organisation.meetings.last
  @meeting.resolutions << @resolutions
end

Given(/^minutes have been entered for the meeting$/) do
  @meeting ||= @organisation.meetings.last
  @meeting.agenda_items.each do |agenda_item|
    agenda_item.minutes = Faker::Lorem.paragraph
    agenda_item.save!
  end
  @meeting.minutes = Faker::Lorem.paragraph
  @meeting.save!
end

When(/^I choose the date of discussion$/) do
  select('2011', :from => 'meeting[happened_on(1i)]')
  select('May', :from => 'meeting[happened_on(2i)]')
  select('1', :from => 'meeting[happened_on(3i)]')
end

When(/^I check the first two directors' checkboxes$/) do
  @company ||= Company.last
  directors = @company.members.where(
    :member_class_id => @company.member_classes.find_by_name('Director').id
  ).limit(2).order('id ASC')
  directors.each do |director|
    check(director.name)
  end
end

When(/^I choose a date for the meeting$/) do
  select_meeting_date
end

When(/^I enter a start time for the meeting$/) do
  fill_in_start_time
end

When(/^I choose a start time for the meeting$/) do
  select_start_time
end

When(/^I enter a venue for the meeting$/) do
  fill_in_venue
end

When(/^I enter the business to be transacted during the meeting$/) do
  fill_in_agenda
end

When(/^I convene a General Meeting$/) do
  visit(new_general_meeting_path)
  select_meeting_date
  select_start_time
  fill_in_venue
  check_certification
  click_button("Confirm and convene the meeting")
end

When(/^I enter details for the meeting$/) do
  select_meeting_date
  select_start_time
  fill_in_venue
  check_certification
end

When(/^I select one of the draft resolutions to be considered at the meeting$/) do
  draft_resolutions = @organisation.resolutions.draft
  check("general_meeting[existing_resolutions_attributes][0][attached]")
end

When(/^I convene the meeting$/) do
  click_button("Confirm and convene the meeting")
end

When(/^I begin to convene an AGM$/) do
  visit(new_annual_general_meeting_path)
  select_meeting_date
  select_start_time
  fill_in_venue
end

When(/^I enter the date of the meeting$/) do
  select('2011', :from => 'minute[happened_on(1i)]')
  select('May', :from => 'minute[happened_on(2i)]')
  select('1', :from => 'minute[happened_on(3i)]')
end

When(/^I choose "(.*?)" from the list of meeting types$/) do |meeting_type|
  select(meeting_type, :from => 'minute[meeting_class]')
end

When(/^I enter minutes for the meeting$/) do
  enter_minutes
end

When(/^I enter that all the resolutions were passed$/) do
  @meeting ||= @organisation.meetings.last
  @resolutions ||= @meeting.resolutions

  @resolutions.each do |resolution|
    within('#' + ActionController::RecordIdentifier.dom_id(resolution)) do
      check("Resolution was passed")
    end
  end
end

When(/^I enter other minutes for the meeting$/) do
  enter_minutes
end

When(/^I delete the agenda item "(.*?)"$/) do |title|
  page.first("input[value='#{title}'] ~ a.delete").click
end

When(/^I add a new agenda item "(.*?)"$/) do |title|
  click_link('Add')
  page.first("ol.agenda_items li:last-child input[name*='title']").set(title)
end

When(/^I move the last agenda item up one position$/) do
  page.first("ol.agenda_items li:last-child a.up").click
end

When(/^I view the details for the new meeting$/) do
  @meeting ||= GeneralMeeting.last
  within("#general_meeting_#{@meeting.id}") do
    click_link("View agenda and details")
  end
end

When(/^I follow "(.*?)" for the upcoming meeting$/) do |link|
  @meeting ||= @organisation.meetings.upcoming.last
  within('#' + ActionController::RecordIdentifier.dom_id(@meeting)) do
    click_link(link)
  end
end

When(/^I edit the minutes$/) do
  if page.has_field?('board_meeting[minutes]')
    fill_in('board_meeting[minutes]', :with => "Edited minutes")
  else
    fill_in('general_meeting[minutes]', :with => "Edited minutes")
  end
end

Then(/^the meeting should have the draft resolution I selected attached to its agenda$/) do
  # We selected the first draft resolution on the form
  @resolution ||= @organisation.resolutions.attached.last
  @meeting ||= @organisation.meetings.last

  @meeting.resolutions.should include(@resolution)
end

Then(/^I should see the meeting details I chose in the list of Upcoming (?:Board )Meetings$/) do
  within('.upcoming_meetings') do
    page.should have_content("Board Meeting")
    page.should have_content("4pm")
    page.should have_content("The Meeting Hall")
  end
end

Then(/^I should see a form for recording minutes$/) do
  form_selector = "form[action='/meetings']"

  page.should have_css(form_selector)

  page.should have_css("#{form_selector} select[name='meeting[happened_on(1i)]']")
  page.should have_css("#{form_selector} select[name='meeting[happened_on(2i)]']")
  page.should have_css("#{form_selector} select[name='meeting[happened_on(3i)]']")

  page.should have_css("#{form_selector} textarea[name='meeting[minutes]']")
end

Then(/^I should see a checkbox for each director$/) do
  @company ||= Company.last
  directors = @company.members.where(
    :member_class_id => @company.member_classes.find_by_name('Director').id
  )
  directors.each do |director|
    page.should have_css("input[type='checkbox'][name='meeting[participant_ids][#{director.id}]']")
  end
end

Then(/^I should see the minutes for "([^"]*)" in the timeline$/) do |minutes|
  with_scope("the timeline") do
    page.should have_css("td", :text => minutes)
  end
end

Then(/^I should see the first two directors' names as participants$/) do
  @company ||= Company.last
  directors = @company.members.where(
    :member_class_id => @company.member_classes.find_by_name('Director').id
  ).limit(2).order('id ASC')
  directors.each do |director|
    page.should have_selector('ul.participants li', :text => director.name)
  end
end

Then(/^I should see the minutes$/) do
  @meeting ||= Meeting.last

  @meeting.participants.each do |participant|
    page.should have_selector('ul.participants li', :text => participant.name)
  end

  page.should have_content(@meeting.minutes)

  page.should have_content(@meeting.happened_on.to_s(:long_ordinal))
end

Then(/^I should see the new meeting in the list of Upcoming Meetings$/) do
  @meeting ||= @organisation.meetings.last

  within('.upcoming_meetings') do
    page.should have_css('#' + ActionController::RecordIdentifier.dom_id(@meeting))
  end
end

Then(/^I should see a list of the Directors who are due for retirement$/) do
  # As this is the first AGM, all of the current Directors must stand down.
  within('.directors') do
    @organisation.directors.each do |director|
      page.should have_content(director.name)
    end
  end
end

Then(/^I should see the new AGM in the list of Upcoming Meetings$/) do
  within('.upcoming_meetings') do
    page.should have_content("Annual General Meeting")
  end
end

Then(/^I should see the meeting in the list of Past Meetings$/) do
  @meeting ||= @organisation.meetings.last
  within('.past_meetings') do
    page.should have_css('#' + ActionController::RecordIdentifier.dom_id(@meeting))
  end
end

Then(/^I should see a list of the resolutions attached to the meeting$/) do
  @meeting ||= @organisation.meetings.last
  @resolutions ||= @meeting.resolutions

  @resolutions.each do |resolution|
    page.should have_content(resolution.title)
  end
end

Then(/^I should see the resolutions marked as passed$/) do
  @meeting ||= @organisation.meetings.last
  @resolutions ||= @meeting.resolutions

  @resolutions.each do |resolution|
    page.should have_content("#{resolution.title} was accepted")
  end
end

Then(/^I should see an agenda item "(.*?)"$/) do |agenda_item|
  page.should have_css("input[value='#{agenda_item}']")
end

Then(/^I should see the agenda item "(.*?)" in position (\d+)$/) do |title, position|
  if page.has_css?("#general_meeting_agenda_items_attributes_#{position.to_i - 1}_title")
    page.should have_field("general_meeting_agenda_items_attributes_#{position.to_i - 1}_title", :with => title)
  else
    page.should have_css("ol.agenda_items li:nth-child(#{position})", :text => title)
  end
end

Then(/^I should see a field for each of the standard agenda items$/) do
  page.should have_field("Apologies for Absence")
  page.should have_field("Minutes of Previous Meeting")
  page.should have_field("Any Other Business")
  page.should have_field("Time and date of next meeting")
end

Then(/^I should see the agenda for the upcoming meeting$/) do
  @meeting ||= @organisation.meetings.upcoming.last
  @meeting.agenda_items.each do |agenda_item|
    page.should have_content(agenda_item.title)
  end
  page.should have_content(@meeting.agenda)
end

Then(/^I should see the minutes for the past meeting$/) do
  @meeting ||= @organisation.meetings.past.last
  @meeting.agenda_items.each do |agenda_item|
    page.should have_content(agenda_item.minutes)
  end
  page.should have_content(@meeting.minutes)
end

Then(/^I should see the edited minutes$/) do
  page.should have_content("Edited minutes")
end

Then(/^I should see that all the members have been added as participants$/) do
  @organisation.members.all.each do |member|
    expect(page).to have_css('.participants li', text: member.name)
  end
end
