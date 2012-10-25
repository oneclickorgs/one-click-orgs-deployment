Feature: Viewing share ownership
  In order to keep track of share ownership
  As the Secretary
  I want to view the shareholdings of the members

  Scenario: Secretary views the members' shareholdings
    Given there is a co-op
    And members of the co-op can hold more than one share
    And I am the Secretary of the co-op
    When I go to the Shares page
    Then I should see a list of the shareholdings of the members
