Then(/^I should see a task telling me to deal with the suggested resolution$/) do
  @resolution_proposal ||= @organisation.resolution_proposals.last
  within('.tasks') do
    page.should have_css("a[href='/resolution_proposals/#{@resolution_proposal.to_param}']")
  end
end

Then(/^I should see a notification of the new membership application$/) do
  @member ||= @organisation.members.pending.last
  within('.tasks') do
    page.should have_css("a[href='/members/#{@member.to_param}']")
  end
end

Then(/^I should no longer see a notification of the new membership application$/) do
  @member ||= @organisation.members.last
  within('.tasks') do
    page.should have_no_css("a[href='/members/#{@member.to_param}']")
  end
end

Then(/^I should see a task telling me to vote in the resolution$/) do
  @resolution ||= @organisation.resolutions.last
  within('.tasks') do
    page.should have_content(@resolution.title)
    page.should have_css("a[href='/resolutions/#{@resolution.to_param}']")
  end
end

Then /^I should not see a task telling me to vote in the resolution$/ do
  @resolution ||= @organisation.resolutions.last
  if page.has_css?('.tasks')
    within('.tasks') do
      page.should have_no_content(@resolution.title)
      page.should have_no_css("a[href='/resolutions/#{@resolution.to_param}']")
    end
  else
    page.should have_no_css('.tasks')
  end
end
