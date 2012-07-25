Feature: Appointing new officer
  In order to keep the record of officers up-to-date
  As the secretary
  I want to record the appointment of a new officer
  
  @javascript
  Scenario: Secretary appoints new officer
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is a director named "Claire Simmons"
    When I go to the Directors page
    And I press "Appoint a new Officer"
    And select "Claire Simmons" from "Name"
    And I fill in "Office" with "Treasurer"
    And I certify the appointment
    And I press "Record this appointment"
    Then I should be on the Directors page
    And I should see "Claire Simmons" listed as the "Treasurer"
