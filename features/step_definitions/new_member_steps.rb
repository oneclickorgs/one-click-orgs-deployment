When /^I fill in my details$/ do
  fill_in("First name", :with => "Ben")
  fill_in("Last name", :with => "Godwin")
  fill_in("Email address", :with => "ben@example.com")
  fill_in("Postal address", :with => "1 High Street\nLondon\nE1 1AA")
end

When /^I apply for the necessary number of shares$/ do
  check("I apply for one share")
end

When /^I certify that I am aged 16 years or over$/ do
  check('member[certify_age]')
end
