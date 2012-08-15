Feature: Adjusting shares settings
  In order to record changes to the way shares are handled
  As the Secretary
  I want to adjust the settings to do with shares

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  @javascript
  Scenario: Secretary adjusts the share value
    When I go to the Shares page
    And I press "Adjust share value"
    And I enter a new share value
    And I press "Save"
    Then I should be on the Shares page
    And I should see the new share value

  @javascript
  Scenario: Secretary adjusts the minimum shareholding
    When I go to the Shares page
    And I press "Adjust minimum shareholding"
    And I enter a new minimum shareholding
    And I press "Save"
    Then I should be on the Shares page
    And I should see the new minimum shareholding

  @javascript
  Scenario: Secretary adjusts the interest rate on share capital
    When I go to the Shares page
    And I press "Adjust interest rate"
    And I enter a new interest rate
    And I press "Save"
    Then I should be on the Shares page
    And I should see the new interest rate
