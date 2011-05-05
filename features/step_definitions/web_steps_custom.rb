Then /^the domain should be "([^"]*)"$/ do |domain|
  current_domain = URI.parse(current_url).host
  current_domain.should == domain
end
