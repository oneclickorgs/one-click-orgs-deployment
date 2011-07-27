Feature: Adding a company
  In order to start running a company virtually
  As a director
  I want to add an existing company to the instance
  
  Background:
    Given the application is set up
  
  Scenario: Director adds a company
    Given the domain is the signup domain
    When I go to the new company page
    And I fill in "First name" with "Bob"
    And I fill in "Last name" with "Smith"
    And I fill in "Email address" with "bob@example.com"
    And I fill in "Choose password" with "letmein"
    And I fill in "Confirm password" with "letmein"
    And I fill in "Company's official name" with "Coffee Ventures Ltd"
    And I fill in "One Click Orgs web address" with "coffee"
    And I press "Add company"
    Then I should be on the Votes & Minutes page
    And the subdomain should be "coffee"
