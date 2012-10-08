Feature: Convening a board meeting
  In order to discuss matters with the rest of the board of directors
  As a director
  I want to convene a meeting of the board of directors

  @javascript
  Scenario: Director convenes a meeting of the board of directors
    Given there is a co-op
    And I am a Director of the co-op
    When I go to the Meetings page
    And I press "Convene a meeting of the Board"
    And I choose a date for the meeting
    And I enter a start time for the meeting
    And I enter a venue for the meeting
    And I enter the business to be transacted during the meeting
    And I press "Convene the Board Meeting"
    Then I should be on the Meetings page
    And I should see the meeting details I chose in the list of Upcoming Meetings
    And all the Directors should receive a notification of the board meeting
