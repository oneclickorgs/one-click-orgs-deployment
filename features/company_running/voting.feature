Feature: Voting
  In order to participate in group decisions
  As a director
  I want to vote on proposals that have been made
  
  Background:
    Given the application is set up
    And a company has been added
    And the company has directors
    And I am a director of the company
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Voting on a general proposal
    Given a proposal "Buy more tea" has been made
    When I go to the Votes & Minutes page
    And I press "Support" within the "Buy more tea" proposal
    Then I should see "Vote for proposal cast"
    And I should see "You voted to support this proposal" within the "Buy more tea" proposal
