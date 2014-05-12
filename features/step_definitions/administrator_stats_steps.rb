Given(/^there are some members$/) do
  coops = Coop.make!(2)
  coops.each do |coop|
    coop.members.make!(2)
    coop.members.make!(2, :director)
    coop.members.make!(:secretary)
  end

  coops = Coop.make!(2, :proposed)
  coops.each do |coop|
    coop.members.make!(2)
    coop.members.make!(2, :director)
    coop.members.make!(:secretary)
  end

  coops = Coop.make!(2, :pending)
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

Then(/^I should see a list of all the users in active organisations$/) do
  members = Coop.active.map(&:members).flatten
  members.each do |member|
    expect(page).to have_content(member.name)
    expect(page).to have_content(member.email)
  end
end

Then(/^I should see a list of all the users in proposed organisations$/) do
  members = Coop.proposed.map(&:members).flatten
  members.each do |member|
    expect(page).to have_content(member.name)
    expect(page).to have_content(member.email)
  end
end

Then(/^I should not see any users from draft organisations$/) do
  members = Coop.pending.map(&:members).flatten
  members.each do |member|
    expect(page).to_not have_content(member.name)
    expect(page).to_not have_content(member.email)
  end
end

Then(/^I should not see any users from proposed organisations$/) do
  members = Coop.proposed.map(&:members).flatten
  members.each do |member|
    expect(page).to_not have_content(member.name)
    expect(page).to_not have_content(member.email)
  end
end

Then(/^I should not see any users from active organisations$/) do
  members = Coop.active.map(&:members).flatten
  members.each do |member|
    expect(page).to_not have_content(member.name)
    expect(page).to_not have_content(member.email)
  end
end
