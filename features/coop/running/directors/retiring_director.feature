Feature: Retiring director
  In order to keep the records of directors up-to-date
  As the secretary
  I want to record the retirement of a director
  
  @javascript
  Scenario: Secretary records retirement of a director
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is a director called "Claire Simmons"
    When I go to the Directors page
    And I retire "Claire Simmons"
    And I certify the retirement
    And I save the retirement
    Then I should be on the Directors page
    And I should not see "Claire Simmons" in the list of Directors
