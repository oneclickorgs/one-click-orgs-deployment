require 'action_controller/record_identifier'

def choose_electronic_voting
  if page.has_field?('resolution_draft_false')
    choose "resolution_draft_false"
  else
    choose "board_resolution_draft_false"
  end
end

def choose_draft
  if page.has_field?('resolution_draft_true')
    choose "resolution_draft_true"
  else
    choose "board_resolution_draft_true"
  end
end

When /^I enter the text of the (?:|new )resolution$/ do
  fill_in("Text of the resolution", :with => "All new members should be required to introduce themselves at the next General Meeting.")
end

When /^I choose to allow electronic voting on the resolution$/ do
  choose_electronic_voting
end

When /^I choose to open the resolution for electronic voting$/ do
  choose_electronic_voting
end

When /^I choose to save the resolution for consideration at a future meeting$/ do
  choose_draft
end

When /^I choose to save the resolution for consideration at a future meeting of the board$/ do
  choose_draft
end

When /^I certify that the Board has decided to open this resolution$/ do
  check("resolution_certification")
end

Then /^I should see the new resolution in the list of draft resolutions$/ do
  @resolution ||= @organisation.resolutions.last
  within('.draft_proposals') do
    page.should have_content(@resolution.description)
  end
end

Then /^I should see the new resolution in the list of currently\-open resolutions$/ do
  @resolution ||= @organisation.resolutions.last
  within('.proposals') do
    page.should have_content(@resolution.description)
  end
end

Then /^the new resolution should have voting buttons$/ do
  @resolution ||= @organisation.resolutions.last
  within('#' + ActionController::RecordIdentifier.dom_id(@resolution)) do
    page.should have_css("input[type=submit][value=Support]")
    page.should have_css("input[type=submit][value=Oppose]")
  end
end
