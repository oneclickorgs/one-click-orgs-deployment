Then /^I should see a task telling me to deal with the suggested resolution$/ do
  @resolution_proposal ||= @organisation.resolution_proposals.last
  within('.tasks') do
    page.should have_css("a[href='/resolution_proposals/#{@resolution_proposal.to_param}']")
  end
end
