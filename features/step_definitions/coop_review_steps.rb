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

Given(/^some draft co\-ops have been created$/) do
  @coops = Coop.make!(2, :pending)
  @coops.each do |coop|
    coop.members.make!(:secretary)
    coop.members.make!(2, :director)
  end
end

Given(/^there are some active co\-ops$/) do
  @coops = Coop.make!(2)
  @coops.each do |coop|
    coop.members.make!(2)
    coop.members.make!(2, :director)
    coop.members.make!(:secretary)
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

When(/^I follow the link to edit a member$/) do
  click_link("Edit member")
end

When(/^I change the member's name$/) do
  fill_in('First name', :with => 'Bob')
  fill_in('Last name', :with => 'Smith')
end

When(/^I change the member's address$/) do
  fill_in('Postal address', :with => "1 High Street\nLondon\nN1 1AA")
end

Then(/^I should see the member's new details$/) do
  page.should have_content("Bob Smith")
  page.should have_content("1 High Street")
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

Then(/^I should see a list of the draft co\-ops$/) do
  @coops ||= Coop.pending

  within('.pending_coops') do
    @coops.each do |coop|
      expect(page).to have_content(coop.name)
    end
  end
end

Then(/^I should see a list of the active co\-ops$/) do
  @coops ||= Coop.active
  within('.active_coops') do
    @coops.each do |coop|
      expect(page).to have_content(coop.name)
    end
  end
end

Then(/^I should see the name of the co\-op$/) do
  page.should have_content(@coop.name)
end

Then(/^I should see the (?:|founder )members of the co\-op$/) do
  @coop.members.count.should >= 1

  @coop.members.each do |member|
    page.should have_content(member.name)
    page.should have_content(member.email)
    page.should have_content(member.phone)
    page.should have_content(member.address)
  end
end

Then(/^I should see the directors of the co\-op$/) do
  expect(@coop.directors.count).to be >= 1

  within('.directors') do
    @coop.directors.each do |director|
      page.should have_content(director.name)
    end
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

Then(/^I should see a link to the co\-op's anti\-money laundering form$/) do
  url = admin_coop_document_path(:coop_id => @coop, :id => 'money_laundering', :format => :pdf)
  page.should have_css("a[href='#{url}']")
end
