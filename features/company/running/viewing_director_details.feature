Feature: Viewing director details
  In order to check records of the directors
  As a director
  I want to view the details of a particular director

  Scenario: Director views another member's details
    Given the application is set up
    And there is a company
    And I am a director of the company
    And the subdomain is the organisation's subdomain
    And I have logged in
    And there are other directors of the company
    When I go to another director's profile page
    Then I should see the details of that director's profile
