Feature: Convening an annual general meeting
  In order to deal with annual business of the co-op
  As the Secretary
  I want to convene the Annual General Meeting
  
  Background:
    Given there is a co-op
    And I am the Secretary of the co-op
  
  @wip @javascript
  Scenario: Secretary convenes the Annual General Meeting
    When I go to the Meetings page
    And I press "Convene a General Meeting"
    And I choose a date for the meeting
    And I enter a start time for the meeting
    And I enter a venue for the meeting
    And I check "This is the Annual General Meeting"
    Then I should see a list of the Directors who are due for retirement
    When I certify that the Board has decided to convene the meeting
    And I press "Confirm and convene the meeting"
    Then I should see the new AGM in the list of Upcoming Meetings
    And I should 
  
  @wip @javascript
  Scenario: Secretary opens electronic nominations for new Directors for an AGM
    When I go to convene an AGM
    And I choose to allow electronic nominations for new Directors
    And I choose a closing date for nominations
    And I convene the meeting
    Then electronic nominations for new Directors should be opened
  
  @wip @javascript
  Scenario: Secretary opens electronic voting for new Directors for an AGM
    When I go to convene an AGM
    And I choose to allow electronic voting for new Directors
    And I choose a closing date for voting
    And I convene the meeting
    Then an electronic vote for the new Directors should be prepared
