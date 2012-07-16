Feature: Amending meeting settings
  In order to make our co-op run the way we want it to
  As the secretary
  I want to adjust the way meetings are run
  
  Background:
    Given there is a co-op
    And I am the Secretary of the co-op
  
  @javascript
  Scenario: Secretary increases the notice period for General Meetings
    Given the notice period for General Meetings is "14" days
    When I go to the Meetings page
    And I press "Change the notice period"
    And I enter "21" days
    Then I should see "Extraordinary Resolution is required"
    When I certify that that the Board has proposed this amendment
    And I certify that the resolution has already been passed
    And I press "Amend the notice period"
    Then I should be on the Meetings page
    And I should see that the notice period is "21" days

  @wip
  Scenario: Secretary decreases the notice period for General Meetings
    Given the notice period for General Meetings is "14" days
    When I go to the Meetings page
    And I press "Change the notice period"
    And I enter "7" days
    Then I should see "90% of Members"
    When I certify that that the Board has proposed this amendment
    And I certify that the resolution has already been passed
    And I press "Amend the notice period"
    Then I should be on the Meetings page
    And I should see that the notice period is "7" days

  @wip
  Scenario: Secretary starts a vote to increase the notice period for General Meetings
    Given the notice period for General Meetings is "14" days
    When I go to the Meetings page
    And I press "Change the notice period"
    And I enter "21" days
    Then I should see "Extraordinary Resolutions is required"
    When I certify that that the Board has proposed this amendment
    And I press "Start a vote of Members"
    Then I should see "A draft resolution to increase the General Meeting notice period has been created."
    When I go to the Resolutions page
    Then I should see a draft resolution to increase the General Meeting notice period to 21 days

  @wip
  Scenario: Secretary starts a vote to decrease the notice period for General Meetings
    Given the notice period for General Meetings is "14" days
    When I go to the Meetings page
    And I press "Change the notice period"
    And I enter  "7" days
    Then I should see "90% of Members"
    When I certify that that the Board has proposed this amendment
    And I press "Start a vote of Members"
    Then I should see "A draft resolution to decrease the General Meeting notice period has been created."
    When I go to the Resolutions page
    Then I should see a draft resolution to decrease the General Meeting notice period to 7 days

  @wip
  Scenario: Secretary amends the quorum for General Meetings
    When I go to the Meetings page
    And I press "Change the quorum"
    And I fill in "Number of members" with "5"
    And I fill in "Percentage of membership" with "30%"
    And I press "Start a vote of Members"
    Then I should see "A draft resolution to change the General Meeting quorum has been created."
    When I go to the Resolutions page
    Then I should see a draft Extraordinary Resolution to change the General Meeting quorum
    And the draft resolution should be to change the quorum to the greater of 5 members or 30% of the membership
