Feature: Drafting rules amendments
  In order to change the way the co-op works
  As the Secretary
  I want to record resolutions that change the Rules of the Co-op

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  @javascript
  Scenario: Secretary creates a draft resolution to amend the Name
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the Name of the organisation" from "Type of proposal"
    And I change the Name to "The Tea Co-op"
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Change organisation name to 'The Tea Co-op'"

  @javascript
  Scenario: Secretary creates a draft resolution to amend the Registered Office address
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the Registered Office of the organisation" from "Type of proposal"
    And I change the Registered office address to "1 Main Street"
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Change registered office address to '1 Main Street'"

  @javascript
  Scenario: Secretary creates a draft resolution to amend the Objects
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the Objects of the organisation" from "Type of proposal"
    And I change the Objects to "buy all the tea."
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Change objects to 'buy all the tea.'"

  @javascript
  Scenario: Secretary creates a draft resolution to amend the membership criteria
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the Rules about membership criteria" from "Type of proposal"
    And I choose to allow "User" members
    And I choose to allow "Employee" members
    And I choose to disallow "Supporter" members
    And I choose to disallow "Producer" members
    And I choose to disallow "Consumer" members
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Change the Rules to disallow Supporter Members"
    And I should see a draft resolution "Change the Rules to disallow Producer Members"
    And I should see a draft resolution "Change the Rules to disallow Consumer Members"

  @javascript
  Scenario: Secretary creates a draft resolution to amend shareholding
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the Rules about share capital" from "Type of proposal"
    And I choose that Members hold one share only
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Change the Rules to permit each Member to hold only one share"

  @javascript
  Scenario: Secretary creates a draft resolution to amend the composition of the Board
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the Rules about the composition of the Board" from "Type of proposal"
    And I enter "2" for each of the Board composition fields
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Allow a maximum of 2 User Members on the Board"
    And I should see a draft resolution "Allow a maximum of 2 Employee Members on the Board"

  @javascript
  Scenario: Secretary creates a draft resolution to amend dissolution Rules
    When I go to the Resolutions page
    And I press "Create a proposal"
    And I select "Change the Rules about dissolution" from "Type of proposal"
    And I choose Common Ownership
    And I press "Save this proposal as a draft"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Change the organisation to be a Common Ownership enterprise"
