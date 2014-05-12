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

Given(/^there is a draft resolution$/) do
  @resolution = @organisation.resolutions.make!(:draft)
end

Given(/^there are draft resolutions$/) do
  @resolutions = @organisation.resolutions.make!(2, :draft)
  @resolution = @resolutions.first
end

Given(/^there is a suggested resolution$/) do
  @resolution_proposal = @organisation.resolution_proposals.make!
end

Given(/^I have suggested a resolution$/) do
  @resolution_proposal = @organisation.resolution_proposals.make!(:proposer => @user)
end

Given(/^there is a resolution open for electronic voting$/) do
  @resolution = @organisation.resolutions.make!
end

Given(/^there is a passed resolution to change the organisation name to 'The Tea IPS'$/) do
  @resolution = @organisation.change_text_resolutions.make!(
    :name => 'organisation_name',
    :value => 'The Tea IPS'
  )
  @resolution.force_passed = true
  @resolution.close!
end

Given(/^I have voted to support the resolution$/) do
  @resolution ||= @organisation.resolutions.last
  @user.cast_vote(:for, @resolution)
end

Given(/^a resolution to terminate the directorship of "(.*?)" has been attached to a past General Meeting$/) do |director_name|
  @director = @organisation.directors.find_by_name(director_name)
  raise "Cannot find a Director with the name #{director_name}" unless @director

  @resolution = @organisation.terminate_directorship_resolutions.make!(directorship: @director.directorship)

  @general_meeting = @organisation.general_meetings.make!(:past)
  @general_meeting.resolutions << @resolution
  @general_meeting.save!
end

When(/^I enter the text (?:for|of) the (?:|new )resolution$/) do
  if page.has_field?('Title of the resolution') || page.has_field?('Text of the resolution')
    if page.has_field?('Title of the resolution')
      fill_in("Title of the resolution", :with => "Member introductions")
    end
    if page.has_field?('Text of the resolution')
      fill_in("Text of the resolution", :with => "All new members should be required to introduce themselves at the next General Meeting.")
    end
  else
    fill_in("Title", :with => "Member introductions")
    fill_in("Description", :with => "All new members should be required to introduce themselves at the next General Meeting.")
  end
end

When(/^I choose to open the resolution for electronic voting$/) do
  choose_electronic_voting
end

When(/^I choose to save the resolution for consideration at a future meeting of the board$/) do
  choose_draft
end

When(/^I press "(.*?)" for the draft resolution$/) do |button|
  @resolution ||= @organisation.resolutions.draft.last

  within('#' + ActionController::RecordIdentifier.dom_id(@resolution)) do
    click_button(button)
  end
end

When(/^I press "(.*?)" for the suggested resolution$/) do |button|
  @resolution_proposal ||= @organisation.resolution_proposals.last

  within('#' + ActionController::RecordIdentifier.dom_id(@resolution_proposal)) do
    click_button(button)
  end
end

When(/^I amend the text of the resolution$/) do
  fill_in("Text of the resolution", :with => "New suggested resolution description.")
end

When(/^I save the resolution$/) do
  click_button("Save changes")
end

When(/^I vote to support the resolution$/) do
  @resolution ||= @organisation.resolutions.last
  within('#' + ActionController::RecordIdentifier.dom_id(@resolution)) do
    click_button('Support')
  end
end

When(/^I view more details of the suggested resolution$/) do
  @resolution_proposal ||= @organisation.resolution_proposals.last
  within("#resolution_proposal_#{@resolution_proposal.id}") do
    click_link("View details")
  end
end

When(/^enough of the membership supports the proposal$/) do
  @proposal ||= @organisation.resolution_proposals.last
  @organisation.members.active.each do |member|
    member.cast_vote(:for, @proposal)
  end
end

Then(/^I should see the new resolution in the list of draft resolutions$/) do
  @resolution ||= @organisation.resolutions.last
  within('.draft_proposals') do
    page.should have_content(@resolution.description)
  end
end

Then(/^I should see the (?:|new )resolution in the list of currently\-open resolutions$/) do
  @resolution ||= @organisation.resolutions.last
  click_link('Open for voting') if first('a[href=\'#tab_proposals\']')
  within('.proposals') do
    page.should have_content(@resolution.description)
  end
end

Then(/^I should see the amended resolution text in the list of suggested resolutions$/) do
  within('.resolution_proposals') do
    page.should have_content("New suggested resolution description.")
  end
end

Then(/^the new resolution should have voting buttons$/) do
  @resolution ||= @organisation.resolutions.last
  within('#' + ActionController::RecordIdentifier.dom_id(@resolution)) do
    page.should have_css("input[type=submit][value=Support]")
    page.should have_css("input[type=submit][value=Oppose]")
  end
end

Then(/^I should see an open resolution to (?:increase|decrease) the General Meeting notice period to (\d+) days$/) do |notice_period|
  click_link("Open for voting")
  within('.proposals') do
    page.should have_content("Change notice period for General Meetings to #{notice_period} clear days")
  end
end

Then(/^I should see an open Extraordinary Resolution to change the General Meeting quorum$/) do
  click_link("Open for voting")
  within('.proposals') do
    page.should have_content("quorum")
  end
end

Then(/^the open resolution should be to change the quorum to the greater of (\d+) members or (\d+)% of the membership$/) do |number, percentage|
  within('.proposals') do
    page.should have_content("#{number} members or #{percentage}% of the membership")
  end
end

Then(/^I should see a draft resolution "(.*?)"$/) do |title|
  within('.draft_proposals') do
    page.should have_content(title)
  end
end

Then(/^I should see the suggested resolution in the list of my suggestions$/) do
  @resolution_proposal ||= @organisation.resolution_proposals.last
  within('.my_resolution_proposals') do
    page.should have_content(@resolution_proposal.title)
  end
end

Then(/^I should see a special link to share the proposal$/) do
  @proposal ||= @organisation.proposals.last
  special_link = "/resolution_proposals/#{@proposal.to_param}/support"
  page.should have_content(special_link)
end

Then(/^the proposal should be open for voting as a resolution$/) do
  @proposal ||= @organisation.proposals.last
  @resolution = @organisation.resolutions.last

  @resolution.title.should eq @proposal.title
  @resolution.description.should eq @proposal.description
  @resolution.should be_open
end

Then(/^I should not see the suggested resolution in the list of suggested resolutions$/) do
  @resolution_proposal ||= @organisation.resolution_proposals.last
  if page.has_css?('.resolution_proposals')
    within('.resolution_proposals') do
      page.should have_no_content(@resolution_proposal.title)
      page.should have_no_content(@resolution_proposal.description)
    end
  else
    page.should have_no_css('.resolution_proposals')
  end
end

Then(/^I should not see a notification to process the suggested resolution$/) do
  @resolution_proposal ||= @organisation.resolution_proposals.last
  page.should have_no_css("a[href='/resolution_proposals/#{@resolution_proposal.to_param}']")
end

Then(/^I should see the resolution is open for electronic voting$/) do
  @resolution ||= @organisation.resolutions.last
  click_link("Open for voting")
  page.should have_css(".proposals ##{ActionController::RecordIdentifier.dom_id(@resolution)}")
end
