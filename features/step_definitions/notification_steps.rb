Then /^I should see a welcome notification$/ do
  page.should have_css('.notification', :content => "The draft constitution")
end

Then /^I should see a list of the members who voted in favour of the founding$/ do
  @fap ||= @organisation.found_association_proposals.last
  
  for_members = @fap.votes.where(:for => true).map{|v| v.member}
  
  for_members.each do |m|
    page.should have_content(m.name)
  end
end

Then /^I should not see the member who voted against the founding$/ do
  @fap ||= @organisation.found_association_proposals.last
  
  against_members = @fap.votes.where(:for => false).map{|v| v.member}
  
  against_members.each do |m|
    page.should_not have_content(m.name)
  end
end
