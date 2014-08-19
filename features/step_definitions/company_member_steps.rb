def make_two_other_directors
  @company ||= Company.last
  director_member_class = @company.member_classes.find_by_name('Director')
  @company.members.make!(2, :member_class => director_member_class)
end

Given(/^I am a director of the company$/) do
  @company ||= Company.last
  director_member_class = @company.member_classes.find_by_name('Director')
  @user = @company.members.make!(:member_class => director_member_class)
end

Given(/^there are two other directors of the company$/) do
  make_two_other_directors
end

Given(/^I have been stood down$/) do
  @user.eject!
end

Given(/^there are other directors of the company$/) do
  make_two_other_directors
end

Then(/^I should see the details of that director's profile$/) do
  expect(page).to have_content(@director.name)
  expect(page).to have_content(@director.email)
end
