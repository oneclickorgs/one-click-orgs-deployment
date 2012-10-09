Feature: Amending meeting settings
  In order to make our co-op run the way we want it to
  As the secretary
  I want to adjust the way meetings are run

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  @javascript
  Scenario: Secretary starts a vote to increase the notice period for General Meetings
    Given the notice period for General Meetings is "14" days
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the notice period for General Meetings" from "Type of proposal"
    And I enter "21" days
    Then I should see "Extraordinary Resolution is required"
    And I press "Open this proposal for electronic voting"
    Then I should see "A proposal to increase the General Meeting notice period has been opened for electronic voting."
    When I go to the Resolutions page
    Then I should see the resolution in the list of currently-open resolutions

  @javascript
  Scenario: Secretary starts a vote to decrease the notice period for General Meetings
    Given the notice period for General Meetings is "14" days
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the notice period for General Meetings" from "Type of proposal"
    And I enter "7" days
    Then I should see "90% of Members"
    And I press "Open this proposal for electronic voting"
    Then I should see "A proposal to decrease the General Meeting notice period has been opened for electronic voting."
    When I go to the Resolutions page
    Then I should see an open resolution to decrease the General Meeting notice period to 7 days

  @javascript
  Scenario: Secretary starts a vote to amend the quorum for General Meetings
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the quorum for General Meetings" from "Type of proposal"
    And I fill in "Number of members" with "5"
    And I fill in "Percentage of membership" with "30%"
    And I press "Open this proposal for electronic voting"
    Then I should see "The proposal has been opened for electronic voting."
    When I go to the Resolutions page
    Then I should see an open Extraordinary Resolution to change the General Meeting quorum
    And the open resolution should be to change the quorum to the greater of 5 members or 30% of the membership
