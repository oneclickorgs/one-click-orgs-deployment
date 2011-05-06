Feature: Inviting founding members
  In order to get members of my group involved in the founding of our association
  As a founder
  I want to invite people to become founding members
  
  Background:
    Given the application is set up
    And I have created an organisation
  
  Scenario: Inviting founding members
    When I go to the members page
    And I fill in "Email Address" with "bob@example.com"
    And I fill in "First name" with "Bob"
    And I fill in "Last name" with "Smith"
    And I press "Send invitation"
    Then I should see "Added a new founding member"
    And I should see "Bob Smith" within the list of founding members
    And a founding member invitation email should be sent to "bob@example.com"
