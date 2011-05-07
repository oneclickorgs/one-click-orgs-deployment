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
