Feature: Creating an association
  In order to get my group up and running quickly
  As a member of a group
  I want to create a One Click Orgs association

  Background:
    Given the application is set up
    And the domain is the signup domain

  @javascript
  Scenario: Creating an association
    When I go to the new association page
    And I fill in "First name" with "Bob"
    And I fill in "Last name" with "Smith"
    And I fill in "Email address" with "bob@example.com"
    And I fill in "Choose password" with "letmein"
    And I fill in "Confirm password" with "letmein"
    And I fill in "Association's official name" with "The Tea Club"
    And I fill in "One Click Orgs web address" with "tea"
    And I fill in "What the Association exists for" with "Enjoying tea"
    And I check "I agree to the Terms and Conditions of One Click Orgs"
    And I press "Create draft constitution"
    Then I should be on the constitution page
    And the subdomain should be "tea"
    And I should see a welcome notification
    And I should receive a welcome email

  @javascript
  Scenario: Viewing terms and conditions
    When I go to the new association page
    And I follow "Terms and Conditions"
    Then I should see the One Click Orgs terms and conditions

  Scenario: Viewing terms and conditions without JavaScript
    When I go to the new association page
    And I follow "Terms and Conditions"
    Then I should see the One Click Orgs terms and conditions
