Then /^I should receive a welcome email$/ do
  email = ActionMailer::Base.deliveries.last
  email.to.should == [(@user ||= Member.last).email]
  email.body.should =~ /created a draft constitution/
end
