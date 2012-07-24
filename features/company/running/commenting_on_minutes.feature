Feature: Commenting on minutes
  In order to register my disagreement with the accuracy of some minutes
  As a director
  I want to comment on some minutes
  
  Background:
    Given the application is set up
    And a company has been added
    And I am a director of the company
    And there are two other directors of the company
    And another director has recorded some minutes
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Director comments on minutes
    When I go to the page for the minutes
    And I enter a comment of "I didn't say that!"
    And I press "Save comment"
    Then I should be on the page for the minutes
    And I should see a comment by me saying "I didn't say that!"
