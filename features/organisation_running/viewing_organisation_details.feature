Feature: Viewing draft organisation details
  In order to decide whether I want to join in founding a draft organisation
  As a founding member
  I want to view details of the draft organisation
  
  Background:
    Given the application is set up
    And an organisation is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Viewing votes and proposals
    Given a proposal has been made
    When I go to the voting and proposals page
    Then I should see a list of votes in progress
    And I should see a list of recent activity
  
  Scenario: Viewing the constitution
    When I go to the constitution page
    Then I should see the constitution
  
  Scenario: Viewing the list of members
    Given there are active members
    And there are pending members
    When I go to the members page
    Then I should see the list of members
    And I should see a list of pending members
  
  Scenario: Viewing a member
    When I go to a member's page
    Then I should see the member's details
    And I should see a list of recent activity by the member
