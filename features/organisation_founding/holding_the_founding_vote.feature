Feature: Holding the founding vote
  In order to give our group a legal structure
  As a founding member
  I want to participate in the founding vote
  
  Background:
    Given the application is set up
    And an organisation has been created
    And there are enough members to start the founding vote
    And the founding vote has been started
    And I am a founding member
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Viewing progress of the founding vote
    When I go to the members page
    Then I should see "Not yet voted" within the list of founding members
  
  Scenario: Voting in the founding vote
    When I go to the home page
    Then I should see "Founding vote in progress"
    When I press "Support"
    Then I should see "Vote for proposal cast"
  
  Scenario: Founding vote passes
    Given everyone has voted to support the founding
    When the proposal closer runs
    Then everyone should receive an email saying the founding vote has passed
    And the organisation should be active
