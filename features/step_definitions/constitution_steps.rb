Given(/^the objectives were changed (\d+) days ago$/) do |days_ago|
  days_ago = days_ago.to_i
  @organisation.objectives = Faker::Lorem.sentence
  @organisation.save!
  @organisation.clauses.get_current(:organisation_objectives).update_attribute(:started_at, days_ago.days.ago)
end

When(/^I fill in the organisation name with "([^"]*)"$/) do |value|
  if page.first('input#constitution_proposal_bundle_organisation_name')
    fill_in('constitution_proposal_bundle_organisation_name', :with => value)
  else
    fill_in('constitution_organisation_name', :with => value)
  end
end

When(/^I fill in the objectives with "([^"]*)"$/) do |value|
  if page.first('textarea#constitution_proposal_bundle_objectives')
    fill_in('constitution_proposal_bundle_objectives', :with => value)
  else
    fill_in('constitution_objectives', :with => value)
  end
end

When(/^I choose "([^"]*)" for (.*) decisions$/) do |voting_system, decision_kind|
  within(".#{decision_kind}_decisions") do
    choose(voting_system)
  end
end

Then(/^I should see the dynamic constitution clauses$/) do
  page.should have_css('.dynamic', :text => @organisation.name)
  page.should have_css('.dynamic', :text => @organisation.objectives)

  page.should have_css('.dynamic',
    :text => VotingPeriods.name_for_value(@organisation.constitution.voting_period)
  )

  page.should have_css('.dynamic', :text =>
    @organisation.constitution.voting_system(:general).long_description
  )
  page.should have_css('.dynamic', :text =>
    @organisation.constitution.voting_system(:membership).long_description(:include_received => true)
  )
  page.should have_css('.dynamic', :text =>
    @organisation.constitution.voting_system(:constitution).long_description(:include_received => true)
  )
end

Then(/^I should see the draft constitution$/) do
  @organisation ||= Organisation.last
  page.should have_css('h2', :text => "View the draft constitution")
  step "I should see the dynamic constitution clauses"
end

Then(/^I should see the constitution$/) do
  @organisation ||= Organisation.last
  page.should have_css('h2', :text => "Constitution")
  step "I should see the dynamic constitution clauses"
end

Then(/^I should see a clause with "([^"]*)"$/) do |clause_text|
  page.should have_css('ul.constitution li', :text => Regexp.new(clause_text))
end

Then(/^I should see that the constitution was most recently changed (\d+) days ago$/) do |days_ago|
  days_ago = days_ago.to_i
  expect(page).to have_content("last changed on #{days_ago.days.ago.to_s(:long_date)}")
end
