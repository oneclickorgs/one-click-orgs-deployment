Feature: Commenting on a proposal
  In order to share my opinions about a proposal
  As a member
  I want to leave a comment on a proposal

  Background:
    Given the application is set up
    And an association is active
    And I am a member of the organisation
    And a proposal "Buy more tea" has been made
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Member comments on a proposal
    When I go to the proposal page
    And I enter a comment of "Sounds good to me."
    And I press "Save comment"
    Then I should be on the proposal page
    And I should see a comment by me saying "Sounds good to me."
