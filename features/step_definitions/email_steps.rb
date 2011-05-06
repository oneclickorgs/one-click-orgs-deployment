Then /^I should receive a welcome email$/ do
  email = ActionMailer::Base.deliveries.last
  email.to.should == [(@user ||= Member.last).email]
  email.body.should =~ /created a draft constitution/
end

Then /^a founding member invitation email should be sent to "([^"]*)"$/ do |email_address|
  email = ActionMailer::Base.deliveries.last
  email.to.should == [email_address]
  email.body.should =~ /You've been invited by .* to become a founding member/
end
