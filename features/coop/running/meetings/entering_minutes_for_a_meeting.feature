Feature: Entering minutes for a meeting
  In order to keep records of the business transacted at meetings
  As the Secretary
  I want to enter minutes for past meetings

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  Scenario: Secretary enters minutes for a past meeting already in the system
    Given there has been a past meeting
    And no minutes for the past meeting have been entered yet
    When I go to the Meetings page
    Then I should see "Minutes have not been entered for this meeting yet" for the past meeting
    When I follow "Enter minutes for this meeting" for the past meeting
    And I enter minutes for the meeting
    And I choose the Members who were in attendance
    And I press "Save these minutes"
    Then I should be on the Meetings page
    When I follow "View minutes" for the meeting
    Then I should see the minutes I entered
    And I should see the participants I chose

  # @wip
  # Scenario: Secretary enters minutes for a past meeting the system doesn't know about
  #   When I go to the Meetings page
  #   And I follow "Enter minutes for a meeting not shown here"
  #   And I choose "General Meeting"
  #   And I enter the date of the meeting
  #   And I enter minutes for the meeting
  #   And I choose the Members who where in attendance
  #   And I press "Save these minutes"
  #   Then I should be on the Meetings page
  #   And I should see the meeting in the list of Past Meetings
  #   When I follow "View minutes" for the meeting
  #   Then I should see the minutes I entered
  
  # @wip
  # Scenario: Secretary records results of resolutions for a meeting
  #   Given there has been a past meeting
  #   And there were resolutions attached to the meeting
  #   When I go to the Meetings page
  #   And I follow "Enter minutes for this meeting" for the past meeting
  #   Then I should see a list of the resolutions attached to the meeting
  #   When I enter that all the resolutions were passed
  #   And I enter other minutes for the meeting
  #   And I choose the Members who were in attendance
  #   And I press "Save these minutes"
  #   And I go to the Timeline page
  #   Then I should see the resolutions marked as passed
