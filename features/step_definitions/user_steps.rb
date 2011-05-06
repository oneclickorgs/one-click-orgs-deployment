Given /^I am a founding member$/ do
  @user = @organisation.members.make(:pending, :member_class => @organisation.member_classes.find_by_name("Founding Member"))
end
