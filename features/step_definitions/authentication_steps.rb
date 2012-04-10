def user_logs_in
  visit '/'
  fill_in('Email', :with => @user.email)
  fill_in('Password', :with => @user.password)
  click_button("Login")
end

Given /^I have logged in$/ do
  user_logs_in
end

When /^I log in$/ do
  user_logs_in
end

When /^I try to log in$/ do
  user_logs_in
end

Then /^I should not be logged in$/ do
  page.should have_no_content("Logout")
end
