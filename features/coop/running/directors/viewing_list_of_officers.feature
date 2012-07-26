Feature: Viewing list of officers
  In order to check the records of officers
  As a member
  I want to view the list of officers
  
  Scenario: Member views the list of officers
    Given there is a co-op
    And I am a Member of the co-op
    When I go to the Directors page
    Then I should see a list of the officers
