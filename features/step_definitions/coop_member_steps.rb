Given /^I am the founder of the draft co\-op$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a founding member of the draft co\-op$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am the (?:S|s)ecretary of the co\-op$/ do
  @coop ||= Coop.last
  
  if @coop.secretary
    @user = @coop.secretary
    
    # We need to be able to read the user's password in order
    # to log in as them. A Member record fetched from the
    # database does not have the raw password stored, so we
    # set a new one here.
    @user.password = @user.password_confirmation = "password"
    @user.save!
  else
    @user = @coop.members.make!(:secretary)
  end
  user_logs_in
end

Given /^I am a (?:M|m)ember of the co\-op$/ do
  @coop ||= Coop.last
  @user = @coop.members.make!(:member)
  user_logs_in
end

Given /^I am a Director of the co\-op$/ do
  @coop ||= Coop.last
  @user = @coop.members.make!(:director)
  user_logs_in
end

Given /^there is a member named "(.*?)"$/ do |name|
  first_name, last_name = name.split(' ')
  @member = @organisation.members.make!(:first_name => first_name, :last_name => last_name)
end

Then /^I should see a list of the members$/ do
  page.should have_css('.members', :text => @user.name)
end

Then /^I should see the details of that member's profile$/ do
  page.should have_content(@member.name)
  page.should have_content(@member.email)
end
