require 'uri'

def last_email
  ActionMailer::Base.deliveries.last
end

def last_email_to(email_address)
  ActionMailer::Base.deliveries.select{|e| e.to.include?(email_address)}.last
end

def all_emails
  ActionMailer::Base.deliveries
end

def follow_link_in_email
  @email ||= last_email
  uri = URI.parse(@email.body.match(/(http:\/\/\S*)/)[1])
  subdomain = uri.host.split('.')[0]
  path = uri.path
  step %Q{the subdomain is "#{subdomain}"}
  visit(path)
end

Given(/^I have received an email inviting me to become a founding member$/) do
  step "I have been invited to become a founding member"
  @email = last_email
end

Given(/^I have received an email inviting me to become a member$/) do
  step "I have been invited to join the organisation"
  @email = last_email
end

Given(/^I have received an email inviting me to sign up as a director$/) do
  step "I have been invited to sign up as a director"
  @email = last_email
end

Given(/^I have received the email saying the founding vote has passed$/) do
  @email = last_email
  @email.subject.should include("has been formed")
end

Given(/^I have received an invitation to become a Founder Member of the draft co\-op$/) do
  @organisation.members.make!(:pending,
    :member_class => @organisation.member_classes.find_by_name!("Founder Member"),
    :send_welcome => true
  )
  @email = last_email
end

When(/^I (?:follow|click) the link in the email$/) do
  follow_link_in_email
end

When(/^I follow the invitation link in the email$/) do
  follow_link_in_email
end

Then(/^I should receive a welcome email$/) do
  @email = last_email
  @email.to.should == [(@user ||= Member.last).email]
  @email.body.should =~ /created a draft constitution/
end

Then(/^a director invitation email should be sent to "([^"]*)"$/) do |email_address|
  @emails = ActionMailer::Base.deliveries.select{|m| m.to == [email_address] && m.body =~ /You have been added as a director/}
  @emails.should_not be_empty
end

Then(/^a founding member invitation email should be sent to "([^"]*)"$/) do |email_address|
  @email = last_email
  @email.to.should == [email_address]
  @email.body.should =~ /You've been invited by .* to become a founding member/
end

Then(/^everyone should receive an email saying that the founding vote has started$/) do
  @organisation.members.each do |member|
    email = ActionMailer::Base.deliveries.select{|mail| mail.to.first == member.email}.first
    email.should be_present
    email.body.should =~ /has initiated a Founding Vote/
  end
end

Then(/^everyone should receive an email saying the founding vote has passed$/) do
  @organisation.members.each do |member|
    email = ActionMailer::Base.deliveries.reverse.select{|mail| mail.to.first == member.email}.first
    email.body.should =~ /The Association has therefore been formed/
  end
end

Then(/^the email should list the members who voted in favour of the founding$/) do
  @email ||= last_email
  @fap ||= @organisation.found_association_proposals.last

  for_members = @fap.votes.where(:for => true).map{|v| v.member}

  for_members.each do |m|
    @email.body.should include(m.name)
  end
end

Then(/^the email should not list the member who voted against the founding$/) do
  @email ||= last_email
  @fap ||= @organisation.found_association_proposals.last

  against_members = @fap.votes.where(:for => false).map{|v| v.member}

  against_members.each do |m|
    @email.body.should_not include(m.name)
  end
end

Then(/^everyone should receive an email notifying them of the proposal$/) do
  @proposal ||= Proposal.last
  @organisation.members.each do |member|
    email = ActionMailer::Base.deliveries.select{|mail| mail.to.first == member.email}.last
    email.body.should =~ Regexp.new(@proposal.title)
  end
end

Then(/^I should receive an email notifying me of the new minutes$/) do
  @email = ActionMailer::Base.deliveries.reverse.select{|mail| mail.to.first == @user.email}.first
  @email.should be_present

  @company ||= Company.last
  @meeting ||= @company.meetings.last

  @email.subject.should include("minutes")
  @email.body.should include(@meeting.minutes)
end

Then(/^I should see a link to the minutes in the email$/) do
  @email ||= last_email

  @meeting ||= Meeting.last

  @email.body.should include("#{@meeting.organisation.domain}/meetings/#{@meeting.to_param}")
end

Then(/^all the directors should receive a "([^"]*)" email$/) do |subject_phrase|
  @organisation.directors.active.each do |director|
    mails = ActionMailer::Base.deliveries.select{|m| m.to.include?(director.email)}
    mails.select{|m| m.subject.include?(subject_phrase)}.should_not be_empty
  end
end

Then(/^I should receive an email saying that member has resigned$/) do
  @member ||= @organisation.members.last
  @email = last_email
  @email.to.should == [(@user ||= @organisation.members.last).email]
  @email.body.should include(@member.name)
  @email.body.should include("resigned")
end

Then(/^the Secretary should receive a notification of the new suggested resolution$/) do
  @secretary ||= @organisation.secretary
  @resolution_proposal ||= @organisation.resolution_proposals.last
  @email = last_email

  @email.to.should == [@secretary.email]
  @email.body.should include(@resolution_proposal.description)
end

Then(/^all the Directors should receive a notification of the board meeting$/) do
  @meeting ||= @organisation.meetings.last
  @directors = @organisation.directors

  @directors.each do |director|
    email = all_emails.select{|e| e.to.include?(director.email)}.last
    email.should be_present
    email.subject.should include("Board Meeting")
    email.body.should include(@meeting.start_time)
    email.body.should include(@meeting.venue)
  end
end

Then(/^all the Members should receive a notification of the new meeting$/) do
  @meeting ||= @organisation.meetings.last
  members = @organisation.members
  members.each do |member|
    email = all_emails.select{|e| e.to.include?(member.email)}.last
    email.should be_present
    email.subject.should include("Meeting")
    email.body.should include(@meeting.start_time)
    email.body.should include(@meeting.venue)
  end
end

Then(/^the Secretary should receive a notification of the new membership application$/) do
  @secretary ||= @organisation.secretary
  @member ||= @organisation.members.last
  @email = last_email

  @email.should be_present
  @email.to.should == [@secretary.email]
  @email.subject.should include('membership application')
  @email.body.should include(@member.name)
end

Then(/^that member should receive a notification of their new directorship$/) do
  @email = last_email

  @email.should be_present
  @email.to.should == [@member.email]
  @email.subject.should include('Director')
end

Then(/^that member should receive a notification of their new office$/) do
  @email = last_email

  @email.should be_present
  @email.to.should == [@director.email]
  @email.subject.should include(@director.office.title)
end

Then(/^the new founding member should receive an invitation email$/) do
  @member ||= @organisation.members.last
  @email = last_email

  @email.should be_present
  @email.to.should == [@member.email]
  @email.subject.should include("Founder Member")
  @email.body.should include(@member.name)
end

Then(/^the new member should receive an invitation email$/) do
  @member ||= @organisation.members.last
  @email = last_email_to(@member.email)

  @email.should be_present
  @email.subject.should include('application')
  @email.body.should include('/i/') # Invitation link
end

Then(/^the Secretary should receive a notification of the new share application$/) do
  @secretary ||= @organisation.secretary

  @share_transaction ||= @organisation.withdrawals.last
  member = @share_transaction.to_account.owner

  @email = last_email

  @email.should be_present
  @email.to.should == [@secretary.email]
  @email.subject.should include('made a new application for shares')
  @email.body.should include(member.name)
end

Then(/^the Secretary should receive a notification of the share withdrawal application$/) do
  @secretary ||= @organisation.secretary

  @share_transaction ||= @organisation.deposits.last
  member = @share_transaction.from_account.owner

  @email = last_email

  @email.should be_present
  @email.to.should == [@secretary.email]
  @email.subject.should include('applied to withdraw shares')
  @email.body.should include(member.name)
end

Then(/^the Secretary should receive a notification of my resignation$/) do
  @secretary ||= @organisation.secretary

  @email = last_email

  @email.should be_present
  @email.to.should == [@secretary.email]
  @email.subject.should include(@user.name)
  @email.subject.should include('resigned')
end

Then(/^I should receive an email notifying me that the co\-op has been approved$/) do
  @email = last_email_to(@user.email)
  @email.should be_present
  @email.subject.should include('registration')
end

Then(/^I should receive an email notifying me about the new draft co\-op$/) do
  @coop ||= Coop.pending.last

  @email = last_email_to(@user.email)
  @email.should be_present
  @email.subject.should include(@coop.name)
  @email.subject.should include('new draft')
end

Then(/^I should receive an email notifying me that the co\-op has been submitted for registration$/) do
  @coop ||= Coop.proposed.last

  @email = last_email_to(@user.email)
  @email.should be_present
  @email.subject.should include(@coop.name)
  @email.subject.should include('submitted')
end
