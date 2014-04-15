Feature: Appointing initial directors
  In order to make our new co-op have the necessary directors and officers
  As the founder of a new co-op
  I want to appoint the initial directors and officers

  Background:
    Given there is a draft co-op
    And I am the founder of the draft co-op

  Scenario: Founder appoints an initial director
    When I go to the Directors page
    And I press "Appoint new Director"
    And I choose a member from the list
    And I press "Record this appointment"
    Then I should see that member in the list of directors
    And that member should receive a notification of their new directorship

  Scenario: Founder appoints an initial officer
    Given there is a Director
    When I go to the Directors page
    And I press "Appoint new Officer"
    And I choose a director from the list of directors
    And I choose 'Secretary' from the list of offices
    And I press "Record this appointment"
    Then I should see that director listed as "Secretary" in the list of Officers
    And that member should receive a notification of their new office
