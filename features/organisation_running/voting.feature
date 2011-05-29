Feature: Voting
  In order to participate in group decisions
  As a member
  I want to vote on proposals that have been made
  
  Background:
    Given the application is set up
    And an organisation is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Voting on a general proposal
    Given a proposal "Buy more tea" has been made
    When I go to the voting and proposals page
    And I press "Support" within the "Buy more tea" proposal
    Then I should see "Vote for proposal cast"
    And I should see "You voted to support this proposal" within the "Buy more tea" proposal
  