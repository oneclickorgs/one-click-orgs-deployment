Feature: Recording minutes
  In order to comply with company articles regarding meetings of directors
  As a director
  I want make a record of minutes of directors' meetings
  
  Background:
    Given the application is set up
    And a company has been added
    And I am a director of the company
    And there are two other directors of the company
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  @javascript
  Scenario: Director records minutes
    Given I am on the Votes & Minutes page
    When I press "Record minutes"
    Then I should see a form for recording minutes
    And I should see a checkbox for each director
    When I choose the date of discussion
    And I check the first two directors' checkboxes
    And I fill in "What was discussed" with "Preferred coffee suppliers."
    And I press "Submit"
    Then I should see the minutes for "Preferred coffee suppliers" in the timeline
    When I follow "Preferred coffee suppliers"
    Then I should see the first two directors' names as participants
