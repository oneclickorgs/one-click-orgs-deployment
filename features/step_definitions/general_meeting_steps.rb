Then /^I should see the resolution in the list of resolutions to be considered at the meeting$/ do
  @resolution ||= @organisation.resolutions.last
  page.should have_css(".resolutions", :text => @resolution.title)
end
