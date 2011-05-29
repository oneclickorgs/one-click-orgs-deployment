Feature: Creating an organisation
  In order to get my group up and running quickly
  As a member of a group
  I want to create a One Click Orgs org
  
  Background:
    Given the application is set up
  
  @javascript
  Scenario: Creating an organisation
    When the domain is the signup domain
    And I go to the signup page
    And I fill in "First name" with "Bob"
    And I fill in "Last name" with "Smith"
    And I fill in "Email address" with "bob@example.com"
    And I fill in "Choose password" with "letmein"
    And I fill in "Confirm password" with "letmein"
    And I fill in "Association's official name" with "The Tea Club"
    And I fill in "One Click Orgs web address" with "tea"
    And I fill in "What the Association exists for" with "Enjoying tea"
    And I press "Create draft constitution"
    And I press "I accept the terms"
    Then I should be on the constitution page
    And the subdomain should be "tea"
    And I should see a welcome notification
    And I should receive a welcome email
