Feature: Entering minutes for an Annual General Meeting
  In order to keep records of the business transacted at the Annual General Meeting
  As the Secretary
  I want to enter minutes for the Annual General Meeting

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  @javascript
  Scenario: Secretary enters minutes for a past AGM already in the system
    Given there has been a past AGM
    And no minutes for the past AGM have been entered yet
    When I go to the Meetings page
    Then I should see "Minutes have not been entered for this meeting yet" for the past AGM
    When I follow "Enter minutes for this meeting" for the past AGM
    Then I should see a field for each of the standard agenda items
    When I enter minutes for the AGM
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    Then I should be on the Meetings page
    When I follow "View minutes" for the AGM
    Then I should see the minutes I entered
    And I should see the participants I chose

  @javascript
  Scenario: Secretary enters minutes for a past AGM the system doesn't know about
    When I go to the Meetings page
    And I follow "Enter minutes for a meeting not shown here"
    And I choose "Annual General Meeting" from the list of meeting types
    And I enter the date of the meeting
    And I enter minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    Then I should be on the Meetings page
    And I should see the AGM in the list of Past Meetings
    When I follow "View minutes" for the AGM
    Then I should see the minutes I entered

  @javascript
  Scenario: Secretary records results of resolutions for an AGM
    Given there has been a past AGM
    And the AGM has no minutes yet
    And there were resolutions attached to the AGM
    When I go to the Meetings page
    And I follow "Enter minutes for this meeting" for the past AGM
    Then I should see a list of the resolutions attached to the meeting
    When I enter that all the resolutions were passed
    And I enter other minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    And I go to the Proposals page
    And I open the "Outcomes" tab
    Then I should see the resolutions marked as passed
