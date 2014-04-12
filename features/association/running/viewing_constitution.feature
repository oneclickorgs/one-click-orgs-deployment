Feature: Viewing the constitution
  In order to understand my association
  As a member
  I want to view the constitution of my association

  Background:
    Given the application is set up
    And an association is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in

  Scenario: Viewing the constitution
    When I go to the constitution page
    Then I should see the constitution

  Scenario: Viewing when the constitution was last changed
    Given the association was founded a week ago
    And the objectives were changed 3 days ago
    When I go to the constitution page
    Then I should see that the constitution was most recently changed 3 days ago
