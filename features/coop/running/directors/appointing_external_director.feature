Feature: Appointing external Director
  In order to bring particular skills or experience to the co-op
  As a Secretary
  I want to appoint an external Director

  Scenario: Secretary appoints an external Director
    Given there is a co-op
    And I am the Secretary of the co-op
    When I go to the Directors page
    And I press "Appoint new Director"
    And I follow "Appoint a non-member Director"
    And I fill in "First name" with "Jane"
    And I fill in "Last name" with "Spencer"
    And I fill in "Email address" with "jane@example.com"
    And I press "Record this appointment"
    Then I should be on the Directors page
    And I should see "Jane Spencer" in the list of Directors
