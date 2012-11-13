Feature: Managing membership issues
  In order to respond to the needs of members and applicants
  As the Secretary
  I want to manage issues of membership that arise

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  Scenario: Secretary processes a new membership application
    Given a membership application has been received
    When I go to the dashboard
    Then I should see a notification of the new membership application
    When I follow the link to process the new membership application
    And I press "Accept application"
    Then I should be on the Members page
    And I should see the new member in the list of members
    And the new member should receive an invitation email
    When I go to the dashboard
    Then I should no longer see a notification of the new membership application

  Scenario: Secretary handles a member who has failed to attain the minimum shareholding
    Given there is a member who has failed to attain the minimum shareholding after 12 months
    When the co-op daily job runs
    And I go to the Members page
    Then I should see a notification that the member has failed to attain the minimum shareholding

  Scenario: Secretary handles a member who wishes to resign
    Given a member has resigned
    When I go to the Members page
    Then I should see a notification that the member has resigned
