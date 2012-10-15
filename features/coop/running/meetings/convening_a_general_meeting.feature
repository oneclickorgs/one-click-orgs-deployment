Feature: Convening a general meeting
  In order to give the Members of the Co-op a change to discuss things
  As the Secretary
  I want to convene a General Meeting

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  @javascript
  Scenario: Secretary convenes a General Meeting using the default meeting template
    When I go to the Meetings page
    And I press "Convene a General Meeting"
    Then I should see an agenda item "Apologies for Absence"
    And I should see an agenda item "Minutes of Previous Meeting"
    And I should see an agenda item "Any Other Business"
    And I should see an agenda item "Time and date of next meeting"
    When I choose a date for the meeting
    And I choose a start time for the meeting
    And I enter a venue for the meeting
    And I press "Confirm and convene the meeting"
    Then I should be on the Meetings page
    And I should see the new meeting in the list of Upcoming Meetings

  @javascript
  Scenario: Secretary customises the default agenda items
    When I go to the Meetings page
    And I press "Convene a General Meeting"
    And I choose a date for the meeting
    And I choose a start time for the meeting
    And I enter a venue for the meeting
    When I delete the agenda item "Time and date of next meeting"
    And I add a new agenda item "Discussion about meeting scheduling"
    And I move the last agenda item up one position
    Then I should see the agenda item "Apologies for Absence" in position 1
    And I should see the agenda item "Minutes of Previous Meeting" in position 2
    And I should see the agenda item "Discussion about meeting scheduling" in position 3
    And I should see the agenda item "Any Other Business" in position 4
    When I press "Confirm and convene the meeting"
    And I view the details for the new meeting
    Then I should see the agenda item "Apologies for Absence" in position 1
    And I should see the agenda item "Minutes of Previous Meeting" in position 2
    And I should see the agenda item "Discussion about meeting scheduling" in position 3
    And I should see the agenda item "Any Other Business" in position 4

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
