Given /^I have started the founding vote$/ do
  @organisation.found_organisation_proposals.make(:proposer => @user).start
  @organisation.proposed!
end

Given /^the founding vote has been started$/ do
  founder = @organisation.member_classes.where(:name => "Founder").first.members.first
  @organisation.found_organisation_proposals.make(:proposer => founder).start
  @organisation.proposed!
end

Given /^everyone has voted to support the founding$/ do
  fop = @organisation.found_organisation_proposals.first
  @organisation.members.each do |member|
    member.cast_vote(:for, fop.id)
  end
end

When /^the proposal closer runs$/ do
  Proposal.close_proposals
end

Then /^I should see a proposal "([^"]*)"$/ do |proposal_title|
  page.should have_css('.open-proposals h4', :text => proposal_title)
end

Then /^I should see a proposal to add "([^"]*)" as a member$/ do |new_member_name|
  page.should have_css('.open-proposals h4', :text => "Add #{new_member_name} as a member of #{@organisation.name}")
end

Then /^I should see a proposal to eject "([^"]*)"$/ do |member_email|
  @member = @organisation.members.find_by_email(member_email)
  page.should have_css('.open-proposals h4', :text => "Eject #{@member.name} from #{@organisation.name}")
end
