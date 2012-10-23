Given(/^I am the founder of the draft co\-op$/) do
  @organisation ||= Coop.pending.last
  if @organisation.members.founder_members(@organisation).first
    @user = @organisation.members.founder_members(@organisation).first
    @user.password = @user.password_confirmation = "password"
    @user.save!
  else
    @user = @organisation.members.make!(:founder_member)
  end
  user_logs_in
end

Given(/^I am a founding member of the draft co\-op$/) do
  @organsation ||= Coop.pending.last
  @user = @organisation.members.make!(:founder_member)
  user_logs_in
end

Given(/^I am the (?:S|s)ecretary of the co\-op$/) do
  @organisation ||= Coop.last

  if @organisation.secretary
    @user = @organisation.secretary

    # We need to be able to read the user's password in order
    # to log in as them. A Member record fetched from the
    # database does not have the raw password stored, so we
    # set a new one here.
    @user.password = @user.password_confirmation = "password"
    @user.save!
  else
    @user = @organisation.members.make!(:secretary)
  end
  user_logs_in
end

Given(/^I am a (?:M|m)ember of the co\-op$/) do
  @organisation ||= Coop.last
  @user = @organisation.members.make!(:member)
  user_logs_in
end

Given(/^I am a Director of the co\-op$/) do
  @organisation ||= Coop.last
  @user = @organisation.members.make!(:director)
  user_logs_in
end

Given(/^I am the founder of a new co\-op$/) do
  set_up_application_if_necessary
  @coop = @organisation = Coop.make!(:pending)
  @user = @coop.members.make!(:founder_member)
  set_subdomain_to_organisation
  user_logs_in
end

Given(/^there is a member named "(.*?)"$/) do |name|
  first_name, last_name = name.split(' ')
  @member = @organisation.members.make!(:first_name => first_name, :last_name => last_name)
end

Given(/^a member has resigned$/) do
  @member = @organisation.members.make!
  @member.resign!
end

When(/^I enter a new founding member's details$/) do
  fill_in("Email address", :with => "bob@example.com")
  fill_in("First name", :with => "Bob")
  fill_in("Last name", :with => "Smith")
end

When(/^I enter new text for the membership application form$/) do
  fill_in("organisation[membership_application_text]", :with => "You must live locally.")
end

When(/^I certify that the new text was agreed by the Directors$/) do
  check('organisation[certification]')
end

When(/^I confirm that I want to resign$/) do
  click_button("Resign")
end

Then(/^I should see a list of the members$/) do
  page.should have_css('.members', :text => @user.name)
end

Then(/^I should see the details of that member's profile$/) do
  page.should have_content(@member.name)
  page.should have_content(@member.email)
end

Then(/^I should be a Founder Member of the draft co\-op$/) do
  @organisation ||= Coop.pending.last

  # Figure out the current logged-in user by looking for the 'edit your profile' link
  # FIXME: This is disgusting.
  id = find_link("Edit your account")[:href].match(/(\d+)/)[1].to_i
  @user = @organisation.members.find(id)

  @user.member_class.name.should == "Founder Member"
end

Then(/^I should see the new founding member in the list of invited members$/) do
  within('.pending_members') do
    page.should have_content("Bob Smith")
  end
end

Then(/^I should see a list of founding members of the draft co\-op$/) do
  @organisation.founder_members.should_not be_empty
  @organisation.founder_members.each do |founder_member|
    page.should have_content(founder_member.name)
  end
end

Then(/^I should see a notification that the member has resigned$/) do
  page.should have_content "#{@member.name} has resigned"
end
