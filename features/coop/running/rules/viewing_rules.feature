Feature: Viewing rules
  In order to understand the way the co-op works
  As a Member
  I want to view the Rules of the co-op
  
  Scenario: Member views the Rules
    Given there is a co-op
    And I am a Member of the co-op
    When I go to the Rules page
    Then I should see the rules of the co-op
