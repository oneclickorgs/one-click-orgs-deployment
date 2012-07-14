Given /^I am the founder of the draft co\-op$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a founding member of the draft co\-op$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am the (?:S|s)ecretary of the co\-op$/ do
  @coop ||= Coop.last
  @user = @coop.members.make!(:secretary)
  user_logs_in
end

Given /^I am a (?:M|m)ember of the co\-op$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a Director of the co\-op$/ do
  @coop ||= Coop.last
  @user = @coop.members.make!(:director)
  user_logs_in
end
