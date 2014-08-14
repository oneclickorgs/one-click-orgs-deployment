def make_general_meeting_proposal_proposed_by_other_member
  member = @organisation.members.make!
  @general_meeting_proposal = @organisation.general_meeting_proposals.make!(proposer: member, description: 'Discuss the inactivity of the board.')
end

Given(/^another member has created an application to convene a general meeting$/) do
  make_general_meeting_proposal_proposed_by_other_member
end

Given(/^an application to convene a general meeting has been created$/) do
  make_general_meeting_proposal_proposed_by_other_member
end

When(/^I enter the purpose of the meeting$/) do
  fill_in('general_meeting_proposal[description]', with: 'Discuss the inactivity of the board.')
end

When(/^I visit the special link for the general meeting application$/) do
  visit(general_meeting_proposal_path(@general_meeting_proposal))
end

When(/^the general meeting application has reached sufficient signatures$/) do
  extra_votes_needed = (@general_meeting_proposal.voting_system.threshold(@general_meeting_proposal).to_i - @general_meeting_proposal.votes_for) + 1
  @general_meeting_proposal.organisation.members.select{|m| !m.votes.where(proposal_id: @general_meeting_proposal.id).exists?}[0..(extra_votes_needed-1)].each do |m|
    m.cast_vote(:for, @general_meeting_proposal)
  end
end

When(/^I follow the link to view more details about the general meeting application$/) do
  click_link('View details of the application.')
end

Then(/^I should see a special link to share the application$/) do
  @general_meeting_proposal ||= @organisation.general_meeting_proposals.last
  expect(page).to have_css("a[href$='#{general_meeting_proposal_path(@general_meeting_proposal)}']")
end

Then(/^I should see the purpose of the meeting$/) do
  expect(page).to have_content('Discuss the inactivity of the board.')
end

Then(/^I should see the name of the member who created the application$/) do
  expect(page).to have_content(@general_meeting_proposal.proposer.name)
end

Then(/^I should see that I have signed the general meeting application$/) do
  expect(page).to have_content('You have already supported this application.')
end

Then(/^I should see a notification of the general meeting application$/) do
  expect(page).to have_content('application to convene a General Meeting')
end

Then(/^I should see the purpose of the general meeting$/) do
  expect(page).to have_content('Discuss the inactivity of the board.')
end

Then(/^I should see the names of the members who signed the general meeting application$/) do
  supporting_members = @general_meeting_proposal.votes.where(for: true).map{|v| v.member}
  expect(supporting_members).to_not be_empty
  supporting_members.each do |m|
    expect(page).to have_content(m.name)
  end
end
