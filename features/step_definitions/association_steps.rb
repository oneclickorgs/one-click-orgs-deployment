Given(/^I have created an association$/) do
  step "an association has been created"
  @user = @founder
  step "the subdomain is the organisation's subdomain"
  step "I have logged in"
end

Given(/^an association has been created$/) do
  @organisation = @association = Association.make!(:state => 'pending')
  @founder = @organisation.members.make!(
    :member_class => @organisation.member_classes.find_by_name("Founder"),
    :inducted_at => nil,
    :state => 'pending'
  )
end

Given(/^there are enough members to start the founding vote$/) do
  extra_members_needed = 3 - @organisation.members.count
  if extra_members_needed > 0
    # Add one extra so we can test what happens when someone abstains or
    # votes against the founding.
    (extra_members_needed + 1).times do
      @organisation.members.make!(:pending,
        :member_class => @organisation.member_classes.find_by_name("Founding Member")
      )
    end
  end
end

Given(/^an association is active$/) do
  @organisation = @association = Association.make!(:state => 'pending')
  @organisation.members.make!(:pending, member_class: @organisation.member_classes.find_by_name("Founder"))
  2.times do
    @organisation.members.make!(:pending,
      :member_class => @organisation.member_classes.find_by_name("Founding Member")
    )
  end
  fap = @organisation.found_association_proposals.make!
  @organisation.propose!
  @organisation.members.each{|m| m.cast_vote(:for, fap)}
  fap.close!
  expect(fap.state).to eq('accepted')
  @organisation.reload
  expect(@organisation).to be_active
end

When(/^I create an association$/) do
  step "I have created an association"
end

Then(/^the organisation should be active$/) do
  @organisation.reload.should be_active
end

Then(/^I should see the One Click Orgs terms and conditions$/) do
  expect(page).to have_content('The One Click Orgs platform is provided by the One Click Orgs Association')
end

Then(/^I should see One Click Orgs' warnings for Founding Members$/) do
  expect(page).to have_content('If you are founding an Association you should read the following warnings')
end
