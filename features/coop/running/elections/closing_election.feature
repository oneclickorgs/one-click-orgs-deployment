Feature: Closing election
  In order to see how a board election turned out
  As a member
  I want to view the results of an election

  Background:
    Given there is a co-op
    And I am a Member of the co-op

  @wip
  Scenario: Member views results of an election
    Given there is an election which is due to close
    And ballots have been cast on the election
    When the election closer runs
    And I visit the directors page
    Then I should see the results of the election
