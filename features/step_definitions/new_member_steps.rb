Given(/^a membership application has been received$/) do
  @member = @organisation.members.make!(:pending)
end

When(/^I follow the link to process the new membership application$/) do
  click_link("Process application.")
end

When(/^I fill in my details$/) do
  fill_in("First name", :with => "Ben")
  fill_in("Last name", :with => "Godwin")
  fill_in("Email address", :with => "ben@example.com")
  fill_in("Postal address", :with => "1 High Street\nLondon\nE1 1AA")
end

When(/^I apply for the necessary number of shares$/) do
  check("I apply for one share")
end

When(/^I certify that I am aged 16 years or over$/) do
  check('member[certify_age]')
end

Then(/^I should see the new member in the list of members$/) do
  @member ||= @organisation.members.last
  within('.members') do
    page.should have_content(@member.name)
  end
end
