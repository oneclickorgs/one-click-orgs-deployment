Given /^I am a founding member$/ do
  @user = @organisation.members.make(:pending, :member_class => @organisation.member_classes.find_by_name("Founding Member"))
end

Given /^I have been invited to become a founding member$/ do
  @organisation.members.make(:pending,
    :member_class => @organisation.member_classes.find_by_name("Founding Member"),
    :send_welcome => true
  )
end
