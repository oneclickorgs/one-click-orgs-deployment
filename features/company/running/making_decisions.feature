Feature: Making decisions
  In order to make group decisions official
  As a director
  I want passed votes to be enacted as decisions
  
  Background:
    Given the application is set up
    And a company has been added
    And the company has directors
    And I am a director of the company
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: A general vote passes
    Given a proposal "Buy more tea" has been made
    When enough people vote in support of the proposal
    And the proposal closer runs
    And I go to the voting and proposals page
    Then I should see "A decision was made: Buy more tea"
