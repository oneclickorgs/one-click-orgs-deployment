Given(/^I am a founding member$/) do
  @user = @organisation.members.make!(:pending, :member_class => @organisation.member_classes.find_by_name("Founding Member"))
end

Given(/^I have been invited to become a founding member$/) do
  @organisation.members.make!(:pending,
    :member_class => @organisation.member_classes.find_by_name("Founding Member"),
    :send_welcome => true
  )
end

Given(/^I have been invited to join the organisation$/) do
  @user ||= @organisation.members.make!(:pending, :send_welcome => true)
  @user.should_not be_inducted
end

Given(/^I am a member of the organisation$/) do
  @user = @organisation.members.make!(
    :member_class => @organisation.member_classes.find_by_name('Member')
  )
end

Given(/^I have been invited to sign up as a director$/) do
  @user ||= @organisation.directors.make!(:send_welcome => true, :state => 'pending')
end

Then(/^my email should be "([^"]*)"$/) do |email|
  @user.reload.email.should == email
end
