Feature: Appointing new director
  In order to keep the record of directors up-to-date
  As the secretary
  I want to record the appointment of a new director

  Scenario: Secretary appoints new director
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is a member named "Claire Simmons"
    When I go to the Directors page
    And I press "Appoint new Director"
    And I choose "Claire Simmons" from the list of members
    And I certify the appointment
    And I press "Record this appointment"
    Then I should be on the Directors page
    And I should see "Claire Simmons" in the list of directors
