require 'uri'

def last_email
  ActionMailer::Base.deliveries.last
end

Given /^I have received an email inviting me to become a founding member$/ do
  Given "I have been invited to become a founding member"
  @email = last_email
end

When /^I follow the invitation link in the email$/ do
  @email ||= last_email
  uri = URI.parse(@email.body.match(/ (http:\/\/.*?) /)[1])
  subdomain = uri.host.split('.')[0]
  path = uri.path
  Given %Q{the subdomain is "#{subdomain}"}
  visit(path)
end

Then /^I should receive a welcome email$/ do
  @email = last_email
  @email.to.should == [(@user ||= Member.last).email]
  @email.body.should =~ /created a draft constitution/
end

Then /^a founding member invitation email should be sent to "([^"]*)"$/ do |email_address|
  @email = last_email
  @email.to.should == [email_address]
  @email.body.should =~ /You've been invited by .* to become a founding member/
end
