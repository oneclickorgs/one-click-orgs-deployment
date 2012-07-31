Given /^there is an electronic vote for new directors in progress$/ do
  @nominees = @organisation.members.make!(5)
  @election = @organisation.elections.make!
  @election.nominees = @nominees
  @election.save!
  @election.start!
end

When /^I place my vote for the new directors I want$/ do
  visit(new_election_ballot_path(:election_id => @election))
  
  # Rank first three nominations in reverse order.
  # Don't rank the remaining nominations
  nominations = @election.nominations
  fill_in("ballot[ranking_#{nominations[2].id}]", :with => '1')
  fill_in("ballot[ranking_#{nominations[1].id}]", :with => '2')
  fill_in("ballot[ranking_#{nominations[0].id}]", :with => '3')

  click_button("Save my vote")
end

Then /^my vote should be counted$/ do
  @ballot = @user.ballots.last
  @ballot.should be_present
  
  @election ||= @organisation.elections.last
  nominations = @election.nominations

  @ballot.ranking.should == [
    nominations[2].id,
    nominations[1].id,
    nominations[0].id
  ]
end
