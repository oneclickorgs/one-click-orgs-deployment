Given /^I have started the founding vote$/ do
  @organisation.found_organisation_proposals.make(:proposer => @user).start
  @organisation.proposed!
end

Given /^the founding vote has been started$/ do
  founder = @organisation.member_classes.where(:name => "Founder").first.members.first
  @organisation.found_organisation_proposals.make(:proposer => founder).start
  @organisation.proposed!
end

Given /^another founding vote has been started$/ do
  sleep(1)
  founder = @organisation.member_classes.where(:name => "Founder").first.members.first
  @organisation.found_organisation_proposals.make(:proposer => founder, :title => "A second voting proposal.").start
  @organisation.proposed!
end


Given /^everyone has voted (to support|against) the founding$/ do |vote|
  fop = @organisation.found_organisation_proposals.last
    verdict = (vote == "against") ? "against" : "for"
    @organisation.members.each do |member|
    member.cast_vote(verdict.to_sym, fop.id)
  end
end

Given /^a proposal has been made$/ do
  @organisation.proposals.make(:proposer => @organisation.members.active.first)
end

Given /^a proposal "([^"]*)" has been made$/ do |proposal_title|
  @organisation.proposals.make(
    :title => proposal_title,
    :proposer => @organisation.members.active.first
  )
end

Given /^a proposal has been made to change the organisation name to "([^"]*)"$/ do |new_organisation_name|
  @proposal = @organisation.change_text_proposals.make(
    :title => "Change organisation name to '#{new_organisation_name}'",
    :parameters => {
      'name' => 'organisation_name',
      'value' => new_organisation_name
    },
    :proposer => @organisation.members.active.first
  )
end

Given /^a proposal has been made to add a new member with name "([^"]*)" and email "([^"]*)"$/ do |name, email|
  first_name, last_name = name.split(' ')
  @proposal = @organisation.add_member_proposals.make(
    :parameters => {
      'first_name' => first_name,
      'last_name' => last_name,
      'email' => email
    },
    :title => "Add #{first_name} #{last_name} as a member of #{@organisation.name}",
    :proposer => @organisation.members.active.first
  )
end

Given /^a proposal has been made to eject the member "([^"]*)"$/ do |email|
  member = @organisation.members.active.find_by_email(email)
  @proposal = @organisation.eject_member_proposals.make(
    :parameters => {
      'id' => member.id
    },
    :title => "Eject #{member.first_name} #{member.last_name} from #{@organisation.name}",
    :proposer => @organisation.members.active.first
  )
end

Given /^the voting system for membership decisions is "([^"]*)"$/ do |voting_system|
  @organisation.constitution.change_voting_system('membership', voting_system)
end

Given /^one member voted against the founding$/ do
  @fop ||= @organisation.found_organisation_proposals.last
  
  # Don't make our user vote against the founding
  @members_against = if @user
    [(@organisation.members - [@user]).last]
  else
    [@organisation.members.last]
  end
    
  @members_against.each do |m|
    m.cast_vote(:against, @fop.id)
  end
end

Given /^the founding vote still passed$/ do
  members_in_favour = @organisation.members
  members_in_favour -= @members_against if @members_against
  
  if members_in_favour.length < @organisation.minimum_members_required_for_founding_vote
    raise RuntimeError, "not enough members left to pass founding vote"
  end
  
  @fop ||= @organisation.found_organisation_proposals.last
  
  members_in_favour.each do |m|
    m.cast_vote(:for, @fop.id)
  end
  
  Proposal.close_proposals
  
  @fop.reload
  raise RuntimeError, "expected founding vote to pass" unless @fop.passed?
end

When /^the proposal closer runs$/ do
  Proposal.close_proposals
end

When /^enough people vote in support of the proposal$/ do
  @proposal ||= Proposal.last
  @organisation.members.active.each do |member|
    member.cast_vote(:for, @proposal.id)
  end
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

Then /^I should see a list of votes in progress$/ do
  page.should have_css('.open-proposals h4')
end
