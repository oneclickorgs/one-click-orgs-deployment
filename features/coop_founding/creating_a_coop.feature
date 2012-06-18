Feature: Adding a company
  In order to start running a co-op virtually
  As a director
  I want to create a co-op in the system
  
  Background:
    Given the application is set up
  
  # TODO: This is a simplified creation process, for testing
  # purposes. The final version will most likely include a
  # full 'pending' stage, as for associations.
  Scenario: Director creates a co-op
    Given the domain is the signup domain
    When I go to the new co-op page
    And I fill in "First name" with "Bob"
    And I fill in "Last name" with "Smith"
    And I fill in "Email address" with "bob@example.com"
    And I fill in "Choose password" with "letmein"
    And I fill in "Confirm password" with "letmein"
    And I fill in "Co-op's official name" with "Coffee Ventures"
    And I fill in "One Click Orgs web address" with "coffee"
    And I press "Create co-op"
    Then I should be on the dashboard page
    And the subdomain should be "coffee"
