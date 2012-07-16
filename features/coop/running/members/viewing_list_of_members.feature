Feature: Viewing list of members
  In order to check the records of members
  As a Member
  I want to view the list of members
  
  Scenario: Member views the list of members
    Given there is a co-op
    And I am a Member of the co-op
    When I go to the Members page
    Then I should see a list of the members
