Feature: Viewing dashboard
  In order to keep track of current happenings in the co-op
  As a Member
  I want to view a dashboard of recent and upcoming events, and things that require my attention

  Background:
    Given there is a co-op
    And I am a Member of the co-op
    And I have applied for some shares
    And there is an upcoming General Meeting
    And there is a resolution open for electronic voting

  Scenario: Member views tasks that require their attention
    When I go to the Dashboard page
    Then I should see notifications of issues that require my attention

  Scenario: Member views list of upcoming meetings
    When I go to the Dashboard page
    Then I should see details of the upcoming general meeting

  Scenario: Member views list of open proposals
    When I go to the Dashboard page
    Then I should see that a proposal is open for voting

  Scenario: Member views list of membership and shares tasks
    When I go to the Dashboard page
    Then I should see a task in the Membership and Shares widget
