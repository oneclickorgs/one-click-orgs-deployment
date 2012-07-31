Feature: Stepping down officer
  In order to keep the records of officers up-to-date
  As the secretary
  I want to record the stepping down of an officer
  
  @javascript  
  Scenario: Secretary records the stepping down of an officer
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is an office "Treasurer"
    And the office is occupied by "Claire Simmons"
    When I go to the Directors page
    And I step down "Claire Simmons"
    And I certify the stepping down
    And I save the stepping down
    Then I should be on the Directors page
    And I should not see "Claire Simmons" listed as the "Treasurer"
