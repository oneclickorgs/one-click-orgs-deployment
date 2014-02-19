require 'action_controller/record_identifier'

Given(/^there is a Director$/) do
  @director = @organisation.members.make!(:director)
end

Given(/^there is a director (?:named|called) "(.*?)"$/) do |name|
  first_name, last_name = name.split(' ')
  @director = @organisation.members.make!(:director, :first_name => first_name, :last_name => last_name)
end

Given(/^there is an office "(.*?)"$/) do |title|
  @office = @organisation.offices.make!(:title => title)
end

Given(/^the office is occupied by "(.*?)"$/) do |name|
  @office ||= @organisation.offices.last

  first_name, last_name = name.split(' ')
  director = @organisation.members.make!(:director,
    :first_name => first_name,
    :last_name => last_name
  )

  officership = Officership.make!(:office => @office, :officer => director)

  @office.reload
end

Given(/^we have appointed some initial Directors and Officers$/) do
  # Make a Secretary
  secretary = @organisation.members.make!(:secretary)
  secretary_office = @organisation.offices.find_or_create_by_title('Secretary')
  @organisation.officerships.make!(:officer => secretary, :office => secretary_office)

  # Make another Director
  @organisation.members.make!(:director)
end

Given(/^there are at least two directors$/) do
  @organisation.members.make!(2, :director)
end

When(/^I choose yesterday for the date of election$/) do
  yesterday = 1.day.ago
  select(yesterday.year.to_s, :from => 'director[elected_on(1i)]')
  select(yesterday.strftime('%B'), :from => 'director[elected_on(2i)]')
  select(yesterday.day.to_s, :from => 'director[elected_on(3i)]')
end

When(/^I check the certification checkbox$/) do
  check('director[certification]')
end

When(/^I press "([^"]*)" for another director$/) do |button|
  @director = @company.members.where(["id <> ?", @user.id]).first
  within("tr#director_#{@director.id}") do
    click_button(button)
  end
end

When(/^I check the age check checkbox$/) do
  check('director[age_certification]')
end

Then(/^I should see a form for standing down the director$/) do
  page.should have_selector("form[action='/directors/#{@director.id}/stand_down']")
  within("form[action='/directors/#{@director.id}/stand_down']") do
    page.should have_selector("select[name='director[stood_down_on(1i)]']")
    page.should have_selector("select[name='director[stood_down_on(2i)]']")
    page.should have_selector("select[name='director[stood_down_on(3i)]']")
    page.should have_selector("input[name='director[certification]']")
    page.should have_selector("input[type=submit]")
  end
end

When(/^I submit the form to stand down the director$/) do
  yesterday = 1.day.ago
  within("form[action='/directors/#{@director.id}/stand_down']") do
    select(yesterday.year.to_s, :from => 'director[stood_down_on(1i)]')
    select(yesterday.strftime('%B'), :from => 'director[stood_down_on(2i)]')
    select(yesterday.day.to_s, :from => 'director[stood_down_on(3i)]')
    check('director[certification]')
    click_button("Stand this director down")
  end
end

When(/^I add a new director$/) do
  step 'I go to the Directors page'
  step 'I press "Add a new director"'
  step 'I fill in "Email" with "bob@example.com"'
  step 'I fill in "First name" with "Bob"'
  step 'I fill in "Last name" with "Smith"'
  step 'I choose yesterday for the date of election'
  step 'I check the certification checkbox'
  step 'I check the age check checkbox'
  step 'I press "Add this director"'
end

When(/^I stand down a director$/) do
  step 'I am on the Directors page'
  step 'I press "Stand down" for another director'
  step 'I submit the form to stand down the director'
end

When(/^I certify the appointment$/) do
  form_model = if page.has_field?('directorship[certification]')
    'directorship'
  else
    'officership'
  end

  check("#{form_model}[certification]")

  yesterday = 1.day.ago
  select(yesterday.year.to_s, :from => "#{form_model}[elected_on(1i)]")
  select(yesterday.strftime('%B'), :from => "#{form_model}[elected_on(2i)]")
  select(yesterday.day.to_s, :from => "#{form_model}[elected_on(3i)]")
end

When(/^I step down "(.*?)"$/) do |name|
  member = @organisation.directors.find_by_name(name)
  within("#member_#{member.id}") do
    click_button("Step down")
  end
end

When(/^I certify the stepping down$/) do
  check('officership[certification]')
  yesterday = 1.day.ago
  select(yesterday.year.to_s, :from => 'officership[ended_on(1i)]')
  select(yesterday.strftime('%B'), :from => 'officership[ended_on(2i)]')
  select(yesterday.day.to_s, :from => 'officership[ended_on(3i)]')
end

When(/^I save the stepping down$/) do
  click_button("Record this stepping down")
end

When(/^I retire "(.*?)"$/) do |name|
  member = @organisation.directors.find_by_name(name)
  within("#member_#{member.id}") do
    click_button("Retire")
  end
end

When(/^I certify the retirement$/) do
  check('directorship[certification]')
  yesterday = 1.day.ago
  select(yesterday.year.to_s, :from => 'directorship[ended_on(1i)]')
  select(yesterday.strftime('%B'), :from => 'directorship[ended_on(2i)]')
  select(yesterday.day.to_s, :from => 'directorship[ended_on(3i)]')
end

When(/^I save the retirement$/) do
  click_button("Record this retirement")
end

When(/^I choose a member from the list$/) do
  @member ||= @organisation.members.first
  select(@member.name, :from => 'directorship[director_id]')
end

When(/^I choose "(.*?)" from the list of members$/) do |name|
  select(name, :from => 'directorship[director_id]')
end

When(/^I choose a director from the list of directors$/) do
  @director = @organisation.directors.first
  select(@director.name, :from => 'officership[officer_id]')
end

When(/^I choose "(.*?)" from the list of directors$/) do |name|
  select(name, :from => 'officership[officer_id]')
end

When(/^I choose 'Secretary' from the list of offices$/) do
  select('Secretary', :from => 'officership[office_id]')
end

When(/^I choose "(.*?)" from the list of offices$/) do |title|
  select(title, :from => 'officership[office_id]')
end

When(/^I fill in the new office with "(.*?)"$/) do |title|
  fill_in('office[title]', :with => title)
end

When(/^I press "(.*?)" for the director "(.*?)"$/) do |button_title, director_name|
  director = @organisation.directors.find_by_name(director_name)
  within("#" + ActionController::RecordIdentifier.dom_id(director)) do
    click_button(button_title)
  end
end

Then(/^I should see that director listed as "(.*?)" in the list of Officers$/) do |office|
  within("#member_#{@director.id}") do
    page.should have_content(office)
  end
end

Then(/^I should see that member in the list of directors$/) do
  within('ul.directors') do
    page.should have_content(@member.name)
  end
end

Then(/^I should see "(.*?)" in the list of (?:D|d)irectors$/) do |name|
  within('ul.directors') do
    page.should have_content(name)
  end
end

Then(/^I should not see "(.*?)" in the list of (?:D|d)irectors$/) do |name|
  within('ul.directors') do
    page.should have_no_content(name)
  end
end

Then(/^I should not see the director$/) do
  page.should_not have_selector("tr#director_#{@director.id}")
end

Then(/^I should see a list of the directors$/) do
  director = @organisation.directors.first
  page.should have_css(".directors", :text => director.name)
end

Then(/^I should see a list of the officers$/) do
  officer = @organisation.offices.select{|o| !o.officer.nil?}.last.officer
  within("#member_#{officer.id}") do
    page.should have_content(officer.officership.office_title)
  end
end

Then(/^I should see "(.*?)" listed as the "(.*?)"$/) do |name, office|
  member = @organisation.members.find_by_name(name)
  within("#member_#{member.id}") do
    page.should have_content(office)
  end
end

Then(/^I should not see "(.*?)" listed as the "(.*?)"$/) do |name, office|
  member = @organisation.members.find_by_name(name)
  within("#member_#{member.id}") do
    page.should have_no_content(office)
  end
end

Then(/^I should see a list of the directors of the draft co\-op$/) do
  @organisation.directors.should_not be_empty
  @organisation.directors.each do |director|
    page.should have_content(director.name)
  end
end

Then(/^I should see a list of officers of the draft co\-op$/) do
  @organisation.officers.should_not be_empty
  @organisation.officers.each do |officer|
    page.should have_content(officer.name)
    page.should have_content(officer.office.title)
  end
end

Then(/^I should see "(.*?)" in the list of unoccupied offices$/) do |office_title|
  page.should have_css('ul.offices', :text => office_title)
end
