When(/^I enter a comment of "([^"]*)"$/) do |comment_body|
  fill_in('comment[body]', :with => comment_body)
end

Then(/^I should see a comment by me saying "([^"]*)"$/) do |comment_body|
  page.should have_css('.comment p.attribution a', :text => @user.name)
  page.should have_css('.comment p', :text => comment_body)
end
