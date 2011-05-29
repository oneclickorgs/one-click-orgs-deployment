Then /^I should see a welcome notification$/ do
  page.should have_css('.notification', :content => "The draft constitution")
end
