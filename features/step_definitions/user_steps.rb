Given /^I am a founding member$/ do
  @user = @organisation.members.make(:pending, :member_class => @organisation.member_classes.find_by_name("Founding Member"))
end

Given /^I have been invited to become a founding member$/ do
  @organisation.members.make(:pending,
    :member_class => @organisation.member_classes.find_by_name("Founding Member"),
    :send_welcome => true
  )
end

Given /^there are two other founding members$/ do
  step "there are enough founding members to start the founding vote"
end

Given /^I have been invited to join the organisation$/ do
  @user ||= @organisation.members.make(:inducted_at => nil)
  @user.should_not be_inducted
  @user.send_welcome = true
  @user.send_welcome_if_requested
end

Given /^I am a member of the organisation$/ do
  @user = @organisation.members.make(
    :member_class => @organisation.member_classes.find_by_name('Member')
  )
end
