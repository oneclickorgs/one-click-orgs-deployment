Given /^I have created an organisation$/ do
  Given "an organisation has been created"
  @user = @founder
  Given "the subdomain is the organisation's subdomain"
  Given "I have logged in"
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
  Given %Q{the domain is "#{@organisation.host}"}
end

Given /^the subdomain is the organisation's subdomain$/ do
  Given %Q{the subdomain is "#{@organisation.subdomain}"}
end
