require 'uri'

def last_email
  ActionMailer::Base.deliveries.last
end

def follow_link_in_email
  @email ||= last_email
  uri = URI.parse(@email.body.match(/(http:\/\/\S*)/)[1])
  subdomain = uri.host.split('.')[0]
  path = uri.path
  step %Q{the subdomain is "#{subdomain}"}
  visit(path)
end

Given /^I have received an email inviting me to become a founding member$/ do
  step "I have been invited to become a founding member"
  @email = last_email
end

Given /^I have received an email inviting me to become a member$/ do
  step "I have been invited to join the organisation"
  @email = last_email
end

Given /^I have received an email inviting me to sign up as a director$/ do
  step "I have been invited to sign up as a director"
  @email = last_email
end

Given /^I have received the email saying the founding vote has passed$/ do
  @email = last_email
  @email.subject.should include("has been formed")
end

When /^I click the link in the email$/ do
  follow_link_in_email
end

When /^I follow the invitation link in the email$/ do
  follow_link_in_email
end

Then /^I should receive a welcome email$/ do
  @email = last_email
  @email.to.should == [(@user ||= Member.last).email]
  @email.body.should =~ /created a draft constitution/
end

Then /^a director invitation email should be sent to "([^"]*)"$/ do |email_address|
  @emails = ActionMailer::Base.deliveries.select{|m| m.to == [email_address] && m.body =~ /You have been added as a director/}
  @emails.should_not be_empty
end

Then /^a founding member invitation email should be sent to "([^"]*)"$/ do |email_address|
  @email = last_email
  @email.to.should == [email_address]
  @email.body.should =~ /You've been invited by .* to become a founding member/
end

Then /^everyone should receive an email saying that the founding vote has started$/ do
  @organisation.members.each do |member|
    email = ActionMailer::Base.deliveries.select{|mail| mail.to.first == member.email}.first
    email.should be_present
    email.body.should =~ /has initiated a Founding Vote/
  end
end

Then /^everyone should receive an email saying the founding vote has passed$/ do
  @organisation.members.each do |member|
    email = ActionMailer::Base.deliveries.reverse.select{|mail| mail.to.first == member.email}.first
    email.body.should =~ /The Association has therefore been formed/
  end
end

Then /^the email should list the members who voted in favour of the founding$/ do
  @email ||= last_email
  @fap ||= @organisation.found_association_proposals.last
  
  for_members = @fap.votes.where(:for => true).map{|v| v.member}
  
  for_members.each do |m|
    @email.body.should include(m.name)
  end
end

Then /^the email should not list the member who voted against the founding$/ do
  @email ||= last_email
  @fap ||= @organisation.found_association_proposals.last
  
  against_members = @fap.votes.where(:for => false).map{|v| v.member}
  
  against_members.each do |m|
    @email.body.should_not include(m.name)
  end
end

Then /^everyone should receive an email notifying them of the proposal$/ do
  @proposal ||= Proposal.last
  @organisation.members.each do |member|
    email = ActionMailer::Base.deliveries.reverse.select{|mail| mail.to.first == member.email}.first
    email.body.should =~ Regexp.new(@proposal.title)
  end
end

Then /^I should receive an email notifying me of the new minutes$/ do
  @email = ActionMailer::Base.deliveries.reverse.select{|mail| mail.to.first == @user.email}.first
  @email.should be_present
  
  @company ||= Company.last
  @meeting ||= @company.meetings.last
  
  @email.subject.should include("minutes")
  @email.body.should include(@meeting.minutes)
end

Then /^I should see a link to the minutes in the email$/ do
  @email ||= last_email
  
  @meeting ||= Meeting.last
  
  @email.body.should include("#{@meeting.organisation.domain}/meetings/#{@meeting.to_param}")
end

Then /^all the directors should receive a "([^"]*)" email$/ do |subject_phrase|
  @organisation.directors.active.each do |director|
    mails = ActionMailer::Base.deliveries.select{|m| m.to.include?(director.email)}
    mails.select{|m| m.subject.include?(subject_phrase)}.should_not be_empty
  end
end

Then /^I should receive an email saying that member has resigned$/ do
  @member ||= @organisation.members.last
  @email = last_email
  @email.to.should == [(@user ||= @organisation.members.last).email]
  @email.body.should include(@member.name)
  @email.body.should include("resigned")
end
