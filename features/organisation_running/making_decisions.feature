Feature: Making decisions
  In order to make group decisions official
  As a member
  I want passed votes to be enacted as decisions
  
  Background:
    Given the application is set up
    And an organisation is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: A general vote passes
    Given a proposal "Buy more tea" has been made
    When enough people vote in support of the proposal
    And the proposal closer runs
    And I go to the voting and proposals page
    Then I should see "A decision was made: Buy more tea"
  
  Scenario: A constitutional vote passes
    Given the organisation's name is "The Tea Club"
    And a proposal has been made to change the organisation name to "Tea Club Mark II"
    When enough people vote in support of the proposal
    And the proposal closer runs
    And I go to the voting and proposals page
    Then I should see "A decision was made: Change organisation name to 'Tea Club Mark II'"
    When I go to the constitution page
    Then I should see a clause with "Tea Club Mark II"
  
  Scenario: An vote passes to add a new member
    Given the voting system for membership decisions is "RelativeMajority"
    And a proposal has been made to add a new member with name "Bob Smith" and email "bob@example.com"
    When enough people vote in support of the proposal
    And the proposal closer runs
    And I go to the voting and proposals page
    Then I should see "A decision was made: Add Bob Smith as a member"
    When I go to the members page
    Then I should see "Bob Smith" within the list of pending members
  
  Scenario: An vote passes to eject a member
    Given the voting system for membership decisions is "RelativeMajority"
    And there is a member with name "Bob Smith" and email "bob@example.com"
    And a proposal has been made to eject the member "bob@example.com"
    When enough people vote in support of the proposal
    And the proposal closer runs
    And I go to the voting and proposals page
    Then I should see "A decision was made: Eject Bob Smith"
    When I go to the members page
    Then I should not see "Bob Smith"