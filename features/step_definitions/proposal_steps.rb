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
