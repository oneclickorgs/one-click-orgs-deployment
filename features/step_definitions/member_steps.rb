Then /^I should see the list of founding members$/ do
  @organisation ||= Organisation.last
  
  # raise [Organisation.count, @organisation.member_classes, @organisation.members].inspect
  
  founder_member_class = @organisation.member_classes.find_by_name("Founder")
  founding_member_member_class = @organisation.member_classes.find_by_name("Founding Member")
  
  @organisation.members.all.select{ |m|
    m.member_class == founder_member_class || m.member_class == founding_member_member_class
  }.each do |member|
    page.should have_content member.name
    page.should have_content member.email
  end
end
