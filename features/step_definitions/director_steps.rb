Given /^there is a director named "(.*?)"$/ do |name|
  first_name, last_name = name.split(' ')
  @director = @organisation.members.make!(:director, :first_name => first_name, :last_name => last_name)
end

Given /^there is an office "(.*?)"$/ do |title|
  @organisation.offices.make!(:title => title)
end

When /^I choose yesterday for the date of election$/ do
  yesterday = 1.day.ago
  select(yesterday.year.to_s, :from => 'director[elected_on(1i)]')
  select(yesterday.strftime('%B'), :from => 'director[elected_on(2i)]')
  select(yesterday.day.to_s, :from => 'director[elected_on(3i)]')
end

When /^I check the certification checkbox$/ do
  check('director[certification]')
end

When /^I press "([^"]*)" for another director$/ do |button|
  @director = @company.members.where(["id <> ?", @user.id]).first
  within("tr#director_#{@director.id}") do
    click_button(button)
  end
end

Then /^I should see a form for standing down the director$/ do
  page.should have_selector("form[action='/directors/#{@director.id}/stand_down']")
  within("form[action='/directors/#{@director.id}/stand_down']") do
    page.should have_selector("select[name='director[stood_down_on(1i)]']")
    page.should have_selector("select[name='director[stood_down_on(2i)]']")
    page.should have_selector("select[name='director[stood_down_on(3i)]']")
    page.should have_selector("input[name='director[certification]']")
    page.should have_selector("input[type=submit]")
  end
end

When /^I submit the form to stand down the director$/ do
  yesterday = 1.day.ago
  within("form[action='/directors/#{@director.id}/stand_down']") do
    select(yesterday.year.to_s, :from => 'director[stood_down_on(1i)]')
    select(yesterday.strftime('%B'), :from => 'director[stood_down_on(2i)]')
    select(yesterday.day.to_s, :from => 'director[stood_down_on(3i)]')
    check('director[certification]')
    click_button("Stand this director down")
  end
end

When /^I add a new director$/ do
  step 'I go to the Directors page'
  step 'I press "Add a new director"'
  step 'I fill in "Email" with "bob@example.com"'
  step 'I fill in "First name" with "Bob"'
  step 'I fill in "Last name" with "Smith"'
  step 'I choose yesterday for the date of election'
  step 'I check the certification checkbox'
  step 'I press "Add this director"'
end

When /^I stand down a director$/ do
  step 'I am on the Directors page'
  step 'I press "Stand down" for another director'
  step 'I submit the form to stand down the director'
end

When /^I certify the appointment$/ do
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

Then /^I should see "(.*?)" in the list of directors$/ do |name|
  within('.directors') do
    page.should have_content(name)
  end
end

Then /^I should not see the director$/ do
  page.should_not have_selector("tr#director_#{@director.id}")
end

Then /^I should see a list of the directors$/ do
  director = @organisation.directors.first
  page.should have_css(".directors", :text => director.name)
end

Then /^I should see "(.*?)" listed as the "(.*?)"$/ do |name, office|
  within('.offices') do
    page.should have_css(".#{office.parameterize.underscore}")
    within(".#{office.parameterize.underscore}") do
      page.should have_content(office)
      page.should have_content(name)
    end
  end
end

