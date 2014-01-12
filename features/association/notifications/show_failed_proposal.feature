Feature: Show failed proposal notification
  As a founder
  I want to know when a founding vote fails
  In order to know respond to it

  @javascript
  Scenario: failing vote should show notification
    Given the application is set up
    And an association has been created
    And there are enough members to start the founding vote
    And the founding vote has been started
    And I am a founding member
    And the subdomain is the organisation's subdomain
    And everyone has voted against the founding
    And the proposal closer runs
    And I have logged in
    Then I should see "Sorry, the Founding Vote has failed."
    When another founding vote has been started
    And everyone has voted against the founding
    And the proposal closer runs
    And I go to the home page
    Then I should see "Sorry, the Founding Vote has failed."

  @javascript
  Scenario: The notification for a given subsequent failed founding vote is only shown once
    Given the application is set up
    And an association has been created
    And there are enough members to start the founding vote
    And the founding vote has been started
    And I am a founding member
    And the subdomain is the organisation's subdomain
    And everyone has voted against the founding
    And the proposal closer runs
    And I have logged in
    Then I should see "Sorry, the Founding Vote has failed."
    When another founding vote has been started
    And everyone has voted against the founding
    And the proposal closer runs
    And I go to the home page
    Then I should see "Sorry, the Founding Vote has failed."
    When I go to the members page
    Then I should not see "Sorry, the Founding Vote has failed."
