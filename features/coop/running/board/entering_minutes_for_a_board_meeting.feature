Feature: Entering minutes for a board meeting
  In order to keep records of the business transacted at board meetings
  As the Secretary
  I want to enter minutes for past board meetings

  Background:
    Given there is a co-op
    And there has been a past board meeting

  Scenario: Secretary enters minutes for a past board meeting already in the system
    Given I am the Secretary of the co-op
    And no minutes for the past board meeting have been entered yet
    When I go to the Board page
    Then I should see "Minutes have not been entered for this meeting yet" for the past board meeting
    When I follow "Enter minutes for this meeting" for the past board meeting
    And I enter minutes for the board meeting
    And I choose the Directors who were in attendance
    And I press "Save these minutes"
    Then I should be on the Board page
    When I follow "View minutes" for the board meeting
    Then I should see the minutes I entered
    And I should see the participants I chose

  Scenario: Secretary edits minutes of a board meeting
    Given I am the Secretary of the co-op
    And minutes have been entered for the meeting
    When I go to the Board page
    And I follow "View minutes" for the board meeting
    And I follow "Edit these minutes"
    And I edit the minutes
    And I press "Save these minutes"
    And I follow "View minutes" for the board meeting
    Then I should see the edited minutes

  Scenario: Director enters minutes for a past board meeting already in the system
    Given I am a Director of the co-op
    And no minutes for the past board meeting have been entered yet
    When I go to the Board page
    Then I should see "Minutes have not been entered for this meeting yet" for the past board meeting
    When I follow "Enter minutes for this meeting" for the past board meeting
    And I enter minutes for the board meeting
    And I choose the Directors who were in attendance
    And I press "Save these minutes"
    Then I should be on the Board page
    When I follow "View minutes" for the board meeting
    Then I should see the minutes I entered
    And I should see the participants I chose

  Scenario: Director edits minutes of a board meeting
    Given I am a Director of the co-op
    And minutes have been entered for the meeting
    When I go to the Board page
    And I follow "View minutes" for the board meeting
    And I follow "Edit these minutes"
    And I edit the minutes
    And I press "Save these minutes"
    And I follow "View minutes" for the board meeting
    Then I should see the edited minutes
