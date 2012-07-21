Feature: Making a proposal
  In order to get participation in group decisions
  As a director
  I want to make a proposal
  
  Background:
    Given the application is set up
    And a company has been added
    And I am a director of the company
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  @javascript
  Scenario: Making a proposal
    When I go to the Votes & Minutes page
    And I press "Propose a vote"
    And I fill in "Title" with "We should buy more tea"
    And I fill in "Description" with "So we can drink more tea."
    And I press "Create proposal"
    Then I should be on the proposal page
    And I should see "We should buy more tea"
    And I should see "So we can drink more tea."
    And everyone should receive an email notifying them of the proposal
