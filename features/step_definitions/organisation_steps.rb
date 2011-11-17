Given /^I have created an organisation$/ do
  step "an organisation has been created"
  @user = @founder
  step "the subdomain is the organisation's subdomain"
  step "I have logged in"
end

Given /^an organisation has been created$/ do
  @organisation = Organisation.make
  @organisation.pending!
  @founder = @organisation.members.make(
    :member_class => @organisation.member_classes.find_by_name("Founder"),
    :inducted_at => nil
  )
end

Given /^the domain is the organisation's domain$/ do
  step %Q{the domain is "#{@organisation.host}"}
end

Given /^the subdomain is the organisation's subdomain$/ do
  step %Q{the subdomain is "#{@organisation.subdomain}"}
end

Given /^there are enough members to start the founding vote$/ do
  extra_members_needed = 3 - @organisation.members.count
  if extra_members_needed > 0
    extra_members_needed.times do
      @organisation.members.make(:pending,
        :member_class => @organisation.member_classes.find_by_name("Founding Member")
      )
    end
  end
end

Given /^an organisation is active$/ do
  @organisation = Organisation.make
  @organisation.active!
  3.times do
    @organisation.members.make(
      :member_class => @organisation.member_classes.find_by_name("Member")
    )
  end
end

Given /^the organisation's name is "([^"]*)"$/ do |new_organisation_name|
  @organisation ||= Organisation.last
  @organisation.clauses.set_text!(:organisation_name, new_organisation_name)
end

When /^I create an organisation$/ do
  step "I have created an organisation"
end

Then /^the organisation should be active$/ do
  @organisation.should be_active
end

Then /^I should see a list of recent activity$/ do
  page.should have_css('table.timeline td.timestamp')
end
