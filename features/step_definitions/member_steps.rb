Given /^there is a member "([^"]*)"$/ do |member_email|
  @organisation.members.make(
    :email => member_email,
    :member_class => @organisation.member_classes.find_by_name("Member")
  )
end

Given /^there are active members$/ do
  if @organisation.members.active.count < 1
    @organisation.members.make(
      :member_class => @organisation.member_classes.find_by_name("Member")
    )
  end
end

Given /^there are pending members$/ do
  if @organisation.members.pending.count < 1
    @organisation.members.make(:pending,
      :member_class => @organisation.member_classes.find_by_name("Member")
    )
  end
end

Given /^there is a member with name "([^"]*)" and email "([^"]*)"$/ do |name, email|
  first_name, last_name = name.split(' ')
  @member = @organisation.members.make(
    :first_name => first_name,
    :last_name => last_name,
    :email => email,
    :member_class => @organisation.member_classes.find_by_name("Member")
  )
end

Given /^another member has resigned$/ do
  @member = @organisation.members.make
  @member.resign!
end

Then /^I should see the list of members$/ do
  page.should have_css('table.members td a')
end

Then /^I should see a list of pending members$/ do
  page.should have_css('table.pending_members td a')
end

Then /^I should see the list of founding members$/ do
  @organisation ||= Organisation.last
  
  # raise [Organisation.count, @organisation.member_classes, @organisation.members].inspect
  
  founder_member_class = @organisation.member_classes.find_by_name("Founder")
  founding_member_member_class = @organisation.member_classes.find_by_name("Founding Member")
  
  @organisation.members.all.select{ |m|
    m.member_class == founder_member_class || m.member_class == founding_member_member_class
  }.each do |member|
    page.should have_content member.name
    page.should have_content member.email
  end
end

Then /^I should see the member's details$/ do
  @member ||= @organisation.members.active.last
  page.should have_content(@member.name)
  page.should have_css("a[href='mailto:#{@member.email}']")
end

Then /^I should see a list of recent activity by the member$/ do
  page.should have_css('table.timeline td')
end

When /^I click on the resign link, and confirm my leaving$/ do
  click_link 'Edit your account'
  click_link_or_button "Resign"
  click_link_or_button "Resign"
end

Then /^I should be logged out, with a message telling me I have resigned\.$/ do
  page.should have_css "h2", :text => "You've resigned successfully"
  # page.should have_css '#notice', :text => 'resigned successfully'
  page.should have_content 'resigned successfully'
end

Then /^a message has been sent to the members$/ do
  # pending # express the regexp above with the code you wish you had
end

Then /^added to the timeline$/ do
  pending # express the regexp above with the code you wish you had
end