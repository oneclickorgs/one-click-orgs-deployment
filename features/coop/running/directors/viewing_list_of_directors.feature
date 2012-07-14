Feature: Viewing list of directors
  In order to check the records of directors
  As a member
  I want to view the list of directors
  
  @wip
  Scenario: Member views the list of directors
    Given there is a co-op
    And I am member of the co-op
    When I go to the Directors page
    Then I should see a list of the directors
