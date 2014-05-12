Feature: Proposing a new member
  In order to involve a new person in the running of the association
  As a member
  I want to propose a new member
  
  Background:
    Given the application is set up
    And an association is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Proposing a new member
    When I go to the voting and proposals page
    And I press "Propose a new member"
    And I fill in "Email" with "bob@example.com"
    And I fill in "First name" with "Bob"
    And I fill in "Last name" with "Smith"
    And I press "Invite member"
    Then I should see "Add Member Proposal successfully created"
    And everyone should receive an email notifying them of the proposal
    When I go to the voting and proposals page
    Then I should see a proposal to add "Bob Smith" as a member
