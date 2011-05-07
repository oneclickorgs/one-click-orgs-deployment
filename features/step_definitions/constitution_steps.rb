When /^I choose "([^"]*)" for (.*) decisions$/ do |voting_system, decision_kind|
  within(".#{decision_kind}_decisions") do
    choose(voting_system)
  end
end

Then /^I should see the dynamic constitution clauses$/ do
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

Then /^I should see the draft constitution$/ do
  @organisation ||= Organisation.last
  page.should have_css('h2', :text => "View the draft constitution")
  Then "I should see the dynamic constitution clauses"
end

Then /^I should see the constitution$/ do
  @organisation ||= Organisation.last
  page.should have_css('h2', :text => "Constitution")
  Then "I should see the dynamic constitution clauses"
end

Then /^I should see a clause with "([^"]*)"$/ do |clause_text|
  page.should have_css('ul.constitution li', :text => Regexp.new(clause_text))
end
