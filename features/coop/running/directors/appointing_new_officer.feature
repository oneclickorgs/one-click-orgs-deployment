Feature: Appointing new officer
  In order to keep the record of officers up-to-date
  As the secretary
  I want to record the appointment of a new officer
  
  @javascript
  Scenario: Secretary appoints new officer to a new office
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is a director named "Claire Simmons"
    When I go to the Directors page
    And I press "Appoint a new Officer"
    And select "Claire Simmons" from "Name"
    And I fill in "New office" with "Treasurer"
    And I certify the appointment
    And I press "Record this appointment"
    Then I should be on the Directors page
    And I should see "Claire Simmons" listed as the "Treasurer"

  @javascript
  Scenario: Secretary appoints a new officer to an existing office
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is a director named "Claire Simmons"
    And there is an office "Treasurer"
    When I go to the Directors page
    And I press "Appoint a new Officer"
    And select "Claire Simmons" from "Name"
    And I select "Treasurer" from "Office"
    And I certify the appointment
    And I press "Record this appointment"
    Then I should be on the Directors page
    And I should see "Claire Simmons" listed as the "Treasurer"
