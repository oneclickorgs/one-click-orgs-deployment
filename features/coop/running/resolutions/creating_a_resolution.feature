Feature: Creating a resolution
  In order to bring an issue for decision by the Members
  As the Secretary
  I want to create a resolution

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  @wip @javascript
  Scenario: Secretary creates a resolution for electronic voting
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Other proposal" from "Type of proposal"
    And I enter the text of the resolution
    And I press "Open this proposal for electronic voting"
    Then I should be on the Resolutions page
    And I should see the new resolution in the list of currently-open resolutions

  @wip @javascript
  Scenario: Secretary creates a resolution for consideration at a future meeting
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Other proposal" from "Type of proposal"
    And I enter the text of the resolution
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see the new resolution in the list of draft resolutions
