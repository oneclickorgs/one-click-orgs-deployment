Feature: Show 'founding vote passed' notification
  As a founding member
  I want to know that the founding vote has passed
  In order to know respond to it
  
  Background:
    Given the application is set up
    And an association has been created
    And there are enough members to start the founding vote
    And the founding vote has been started
    And I am a founding member
    And the subdomain is the organisation's subdomain
    And one member voted against the founding
    But the founding vote still passed
    
  Scenario: Founding vote passed notification should list the appropriate members
    When I log in
    And I agree to abide by the constitution
    Then I should see "These are the Founding Members"
    And I should see a list of the members who voted in favour of the founding
    But I should not see the member who voted against the founding
