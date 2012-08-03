Then /^I should not see voting UI$/ do
  page.should have_no_css("form[action^='/votes/vote_for']")
  page.should have_no_content("You voted to")
end
