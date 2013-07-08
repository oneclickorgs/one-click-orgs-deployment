Feature: Forcing a resolution
  In order to deal with an unresponsive board
  As a member
  I want to collaborate with other members to force a resolution to be opened for voting

  @javascript
  Scenario: Member forces a resolution to be opened for voting
    Given there is a co-op
    And I am a Member of the co-op
    When I go to the Proposals page
    And I press "Create a proposal"
    And I fill in "Title" with "Remove John Smith from the Board of Directors"
    And I fill in "Description" with "We all know why."
    And I press "Submit suggestion"
    Then I should see a special link to share the proposal
    When enough of the membership supports the proposal
    And the proposal closer runs
    Then the proposal should be open for voting as a resolution
