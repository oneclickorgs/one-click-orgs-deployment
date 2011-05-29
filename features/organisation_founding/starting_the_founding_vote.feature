Feature: Starting the founding vote
  In order to found our organisation
  As a founder
  I want to start the founding vote
  
  Background:
    Given the application is set up
    And I have created an organisation
    And there are enough members to start the founding vote
  
  @javascript
  Scenario: Starting the founding vote
    When I go to the home page
    And I press "Hold the Founding Vote"
    And I press "Confirm"
    Then I should see "Founding vote in progress"
    And everyone should receive an email saying that the founding vote has started
