Given /^a co\-op has been submitted$/ do
  @coop = @organisation = Coop.make!(:proposed)
end

When /^I press "(.*?)" for the co\-op$/ do |button|
  @coop ||= Coop.proposed.last
  within("#coop_#{@coop.id}") do
    click_button(button)
  end
end

Then /^I should see that the co\-op is approved$/ do
  @coop ||= Coop.active.last
  within('.active_coops') do
    page.should have_content(@coop.name)
  end
end
