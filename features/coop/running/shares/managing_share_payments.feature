Feature: Managing share payments
  In order to respond to members' requests for new shares
  As the Secretary
  I want to process new share applications

  Scenario: Secretary processes a new share application
    Given there is a co-op
    And members of the co-op can hold more than one share
    And I am the Secretary of the co-op
    And a member has made an application for more shares
    When I go to the Shares page
    Then I should see the share application
    When I press "Mark as paid, and allot shares"
    Then I should see that the member's new shares have been allotted
    When I go to the dashboard
    Then I should no longer see a notification about the member's share application