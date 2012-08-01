Feature: Viewing dashboard
  In order to keep track of current happenings in the co-op
  As a Member
  I want to view a dashboard of recent and upcoming events, and things that require my attention

  Background:
    Given there is a co-op
    And I am a Member of the co-op

  Scenario: Member views recent timeline events
    When I go to the Dashboard page
    Then I should see a timeline of recent events in the co-op

  # @wip
  # Scenario: Member views tasks that requite their attention
  #   When I go to the Dashboard page
  #   Then I should see notifications of issues that require my attention

  # @wip
  # Scenario: Member views action buttons for common tasks
  #   When I go to the Dashboard page
  #   Then I should see action buttons for things I commonly want to do
