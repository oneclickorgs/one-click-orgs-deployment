Given /^there is an electronic vote for new directors in progress$/ do
  @nominees = @organisation.members.make!(5)
  @election = @organisation.elections.make!
  @election.nominees = @nominees
  @election.save!
  @election.start!
end

Given /^there is an election which is due to close$/ do
  @nominees = @organisation.members.make!(3)

  @election = @organisation.elections.make!
  @election.seats = 2
  @election.nominees = @nominees
  @election.nominations_closing_date = 1.week.ago
  @election.voting_closing_date = 1.day.ago

  @election.save!

  @election.start!
end

Given /^ballots have been cast on the election$/ do
  @election ||= @organisation.elections.last
  @nominees ||= @election.nominees

  # Array of nominations in same order as @nominees
  nomination_ids = @nominees.map{|nominee| @election.nominations.where(:nominee_id => nominee.id).first.id}

  @balloting_members = @organisation.members.make!(6)

  # A set of ballots that will result in nominees 1 and 2 being elected,
  # and nominee 0 being defeated.

  @election.ballots.make!(
    :member => @balloting_members[0],
    :ranking => [nomination_ids[0], nomination_ids[1]]
  )
  @election.ballots.make!(
    :member => @balloting_members[1],
    :ranking => [nomination_ids[0], nomination_ids[1]]
  )
  @election.ballots.make!(
    :member => @balloting_members[2],
    :ranking => [nomination_ids[0], nomination_ids[1]]
  )
  @election.ballots.make!(
    :member => @balloting_members[3],
    :ranking => [nomination_ids[0], nomination_ids[1]]
  )
  @election.ballots.make!(
    :member => @balloting_members[4],
    :ranking => [nomination_ids[2]]
  )
  @election.ballots.make!(
    :member => @balloting_members[5],
    :ranking => [nomination_ids[2]]
  )

  @ballots = @election.ballots(true)
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

When /^I choose to allow electronic nominations for new Directors$/ do
  check "annual_general_meeting[electronic_nominations]"
end

When /^I choose a closing date for nominations$/ do
  date = 2.weeks.from_now
  select(date.year.to_s, :from => "annual_general_meeting[nominations_closing_date(1i)]")
  select(date.strftime('%B'), :from => "annual_general_meeting[nominations_closing_date(2i)]")
  select(date.day.to_s, :from => "annual_general_meeting[nominations_closing_date(3i)]")
end

When /^I choose to allow electronic voting for new Directors$/ do
  check "annual_general_meeting[electronic_voting]"
end

When /^I choose a closing date for voting$/ do
  date = 4.weeks.from_now
  select(date.year.to_s, :from => "annual_general_meeting[voting_closing_date(1i)]")
  select(date.strftime('%B'), :from => "annual_general_meeting[voting_closing_date(2i)]")
  select(date.day.to_s, :from => "annual_general_meeting[voting_closing_date(3i)]")
end

When /^the election closer runs$/ do
  Election.close_elections
end

Then /^an electronic vote for the new Directors should be prepared$/ do
  election = @organisation.meetings.last.election

  election.should be_present
  election.voting_closing_date.should be_present
end

Then /^electronic nominations for new Directors should be opened$/ do
  election = @organisation.meetings.last.election

  election.should be_present
  election.nominations_closing_date.should be_present
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

Then /^I should see the results of the election$/ do
  page.should have_content("#{@nominees[0].name} was elected.")
  page.should have_content("#{@nominees[1].name} was not elected.")
  page.should have_content("#{@nominees[2].name} was elected.")

end
