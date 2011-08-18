Given /^I have logged in$/ do
  visit '/'
  fill_in('Email', :with => @user.email)
  fill_in('Password', :with => @user.password)
  click_button("Login")
end

When /^I try to log in$/ do
  Given "I have logged in"
end

Then /^I should not be logged in$/ do
  page.should have_no_content("Logout")
end
