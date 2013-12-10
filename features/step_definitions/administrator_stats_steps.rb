Given(/^there are some members$/) do
  coops = Coop.make!(2)
  coops.each do |coop|
    coop.members.make!(2)
    coop.members.make!(2, :director)
    coop.members.make!(:secretary)
  end
end

Then(/^I should see a list of all the users$/) do
  members = Member.all
  members.each do |member|
    expect(page).to have_content(member.name)
    expect(page).to have_content(member.email)
  end
end

