Feature: Viewing rules
  In order to understand the way the co-op works
  As a Member
  I want to view the Rules of the co-op

  Background:
    Given there is a co-op
    And I am a Member of the co-op

  Scenario: Member views the Rules
    When I go to the Rules page
    Then I should see the rules of the co-op

  Scenario: Member views custom fields in the Rules
    When I go to the Rules page
    Then I should see the custom fields in the Rules filled in appropriately

  Scenario: Member downloads a PDF of the Rules
    When I go to the Rules page
    And I follow "PDF"
    Then I should get a ".pdf" download with the name of the organisation
