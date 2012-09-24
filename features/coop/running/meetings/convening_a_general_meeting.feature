Feature: Convening a general meeting
  In order to give the Members of the Co-op a change to discuss things
  As the Secretary
  I want to convene a General Meeting

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  @javascript
  Scenario: Secretary convenes a General Meeting
    When I go to the Meetings page
    And I press "Convene a General Meeting"
    And I choose a date for the meeting
    And I enter a start time for the meeting
    And I enter a venue for the meeting
    And I enter an agenda for the meeting
    And I certify that the Board has decided to convene the meeting
    And I press "Confirm and convene the meeting"
    Then I should be on the Meetings page
    And I should see the new meeting in the list of Upcoming Meetings

  @javascript
  Scenario: Members are notified of a new General Meeting
    When I convene a General Meeting
    Then all the Members should receive a notification of the new meeting

  @javascript
  Scenario: Secretary convenes a General Meeting with resolutions to be considered
    Given there are draft resolutions
    When I go to convene a General Meeting
    And I enter details for the meeting
    And I select one of the draft resolutions to be considered at the meeting
    And I convene the meeting
    Then the meeting should have the draft resolution I selected attached to its agenda
