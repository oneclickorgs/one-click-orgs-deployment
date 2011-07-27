Feature: Proposing ejection of a member
  In order to remove a member who shouldn't be involved anymore
  As a member
  I want to propose the ejection of a member
  
  Background:
    Given the application is set up
    And an association is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Proposing ejection of a member
    Given there is a member "bob@example.com"
    When I go to the member page for "bob@example.com"
    And I press "Create proposal to eject this member"
    Then I should see a proposal to eject "bob@example.com"
    And everyone should receive an email notifying them of the proposal
