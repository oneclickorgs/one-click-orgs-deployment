Feature: Entering minutes for a meeting
  In order to keep records of the business transacted at meetings
  As the Secretary or as a Director
  I want to enter minutes for past meetings

  Background:
    Given there is a co-op

  @javascript
  Scenario: Secretary enters minutes for a past meeting already in the system
    Given I am the Secretary of the co-op
    And there has been a past meeting
    And no minutes for the past meeting have been entered yet
    When I go to the Meetings page
    Then I should see "Minutes have not been entered for this meeting yet" for the past meeting
    When I follow "Enter minutes for this meeting" for the past meeting
    Then I should see a field for each of the standard agenda items
    When I enter minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    Then I should be on the Meetings page
    When I follow "View minutes" for the meeting
    Then I should see the minutes I entered
    And I should see the participants I chose

  @javascript
  Scenario: Secretary enters minutes for a past meeting the system doesn't know about
    Given I am the Secretary of the co-op
    When I go to the Meetings page
    And I follow "Enter minutes for a meeting not shown here"
    And I choose "General Meeting" from the list of meeting types
    And I enter the date of the meeting
    And I enter minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    Then I should be on the Meetings page
    And I should see the meeting in the list of Past Meetings
    When I follow "View minutes" for the meeting
    Then I should see the minutes I entered

  @javascript
  Scenario: Secretary records results of resolutions for a meeting
    Given I am the Secretary of the co-op
    And there has been a past meeting
    And the meeting has no minutes yet
    And there were resolutions attached to the meeting
    When I go to the Meetings page
    And I follow "Enter minutes for this meeting" for the past meeting
    Then I should see a list of the resolutions attached to the meeting
    When I enter that all the resolutions were passed
    And I enter other minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    And I go to the Proposals page
    And I open the "Outcomes" tab
    Then I should see the resolutions marked as passed

  @javascript
  Scenario: Secretary edits minutes of a general meeting
    Given I am the Secretary of the co-op
    And there has been a past meeting
    And minutes have been entered for the meeting
    When I go to the Meetings page
    And I follow "View minutes" for the meeting
    And I follow "Edit these minutes"
    And I edit the minutes
    And I press "Save these minutes"
    And I follow "View minutes" for the meeting
    Then I should see the edited minutes

  @javascript
  Scenario: Director enters minutes for a past meeting already in the system
    Given I am a Director of the co-op
    And there has been a past meeting
    And no minutes for the past meeting have been entered yet
    When I go to the Meetings page
    Then I should see "Minutes have not been entered for this meeting yet" for the past meeting
    When I follow "Enter minutes for this meeting" for the past meeting
    Then I should see a field for each of the standard agenda items
    When I enter minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    Then I should be on the Meetings page
    When I follow "View minutes" for the meeting
    Then I should see the minutes I entered
    And I should see the participants I chose

  @javascript
  Scenario: Director enters minutes for a past meeting the system doesn't know about
    Given I am a Director of the co-op
    When I go to the Meetings page
    And I follow "Enter minutes for a meeting not shown here"
    And I choose "General Meeting" from the list of meeting types
    And I enter the date of the meeting
    And I enter minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    Then I should be on the Meetings page
    And I should see the meeting in the list of Past Meetings
    When I follow "View minutes" for the meeting
    Then I should see the minutes I entered

  @javascript
  Scenario: Director records results of resolutions for a meeting
    Given I am a Director of the co-op
    And there has been a past meeting
    And the meeting has no minutes yet
    And there were resolutions attached to the meeting
    When I go to the Meetings page
    And I follow "Enter minutes for this meeting" for the past meeting
    Then I should see a list of the resolutions attached to the meeting
    When I enter that all the resolutions were passed
    And I enter other minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    And I go to the Proposals page
    And I open the "Outcomes" tab
    Then I should see the resolutions marked as passed

  @javascript
  Scenario: Director edits minutes of a general meeting
    Given I am a Director of the co-op
    And there has been a past meeting
    And minutes have been entered for the meeting
    When I go to the Meetings page
    And I follow "View minutes" for the meeting
    And I follow "Edit these minutes"
    And I edit the minutes
    And I press "Save these minutes"
    And I follow "View minutes" for the meeting
    Then I should see the edited minutes
