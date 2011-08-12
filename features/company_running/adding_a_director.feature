Feature: Adding a director
  In order to reflect changes in directorship
  As a director
  I want to add a new director
  
  Background:
    Given the application is set up
    And a company has been added
    And I am a director of the company
    And there are two other directors of the company
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  @javascript
  Scenario: Director adds a new director
    When I go to the Directors page
    And I press "Add a new director"
    And I fill in "Email" with "bob@example.com"
    And I fill in "First name" with "Bob"
    And I fill in "Last name" with "Smith"
    And I choose yesterday for the date of election
    And I check the certification checkbox
    And I press "Add this director"
    Then I should be on the Directors page
    And I should see "Bob Smith" within the list of directors
    And a director invitation email should be sent to "bob@example.com"
  
  @javascript
  Scenario: Directors are notified of a new director
    When I add a new director
    Then all the directors should receive a "new director" email
