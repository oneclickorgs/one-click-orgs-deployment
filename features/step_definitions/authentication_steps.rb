Given /^I have logged in$/ do
  visit '/'
  fill_in('Email', :with => @user.email)
  fill_in('Password', :with => @user.password)
  click_button("Login")
end
