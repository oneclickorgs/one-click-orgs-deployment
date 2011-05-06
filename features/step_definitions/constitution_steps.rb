Then /^I should see the draft constitution$/ do
  @organisation ||= Organisation.last

  page.should have_css('h2', :text => "View the draft constitution")
  
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
