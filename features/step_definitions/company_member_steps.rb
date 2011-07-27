Given /^I am a director of the company$/ do
  @company ||= Company.last
  director_member_class = @company.member_classes.find_by_name('Director')
  @user = @company.members.make(:member_class => director_member_class)
end

Given /^there are two other directors of the company$/ do
  @company ||= Company.last
  director_member_class = @company.member_classes.find_by_name('Director')
  @company.members.make_n(2, :member_class => director_member_class)
end
