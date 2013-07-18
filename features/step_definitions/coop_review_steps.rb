Given(/^a co\-op has been submitted$/) do
  @coop = @organisation = Coop.make!(:proposed)
  @coop.members.make!
end

Given(/^some co\-ops have been submitted for registration$/) do
  @coops = Coop.make!(2, :proposed)
  @coops.each do |coop|
    coop.members.make!(:secretary)
    coop.members.make!(2, :director)
  end
end

When(/^I press "(.*?)" for the co\-op$/) do |button|
  @coop ||= Coop.proposed.last
  within("#coop_#{@coop.id}") do
    click_button(button)
  end
end

When(/^I follow "(.*?)" for the co\-op$/) do |link|
  @coop ||= Coop.proposed.last
  within("#coop_#{@coop.id}") do
    click_link(link)
  end
end

Then(/^I should see that the co\-op is approved$/) do
  @coop ||= Coop.active.last
  within('.active_coops') do
    page.should have_content(@coop.name)
  end
end

Then(/^I should see a list of the submitted co\-ops$/) do
  @coops ||= Coop.proposed

  within('.proposed_coops') do
    @coops.each do |coop|
      page.should have_content(coop.name)
    end
  end
end

Then(/^I should see the name of the co\-op$/) do
  page.should have_content(@coop.name)
end

Then(/^I should see the founder members of the co\-op$/) do
  @coop.members.count.should >= 1

  @coop.members.each do |member|
    page.should have_content(member.name)
    page.should have_content(member.email)
    page.should have_content(member.phone)
    page.should have_content(member.address)
  end
end

Then(/^I should see a link to the co\-op's rules$/) do
  url = admin_constitution_path(@coop, :format => :pdf)
  page.should have_css("a[href='#{url}']")
end

Then(/^I should see a link to the co\-op's registration form$/) do
  url = admin_registration_form_path(@coop, :format => :pdf)
  page.should have_css("a[href='#{url}']")
end
