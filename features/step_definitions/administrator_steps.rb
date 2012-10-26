Given(/^I am an administrator$/) do
  set_up_application_if_necessary

  @user = Administrator.make!

  set_subdomain_to_signup_subdomain

  visit '/admin'
  fill_in('Email', :with => @user.email)
  fill_in('Password', :with => @user.password)
  click_button("Login")
end
