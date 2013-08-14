Feature: Adding a co-op
  In order to start running a co-op virtually
  As a founder
  I want to create a co-op in the system

  Background:
    Given the application is set up

  Scenario: Founder creates a co-op
    Given the domain is the signup domain
    When I go to the new co-op page
    And I enter my details
    And I enter the new co-op's details
    And I accept the Terms of Use
    And I press "Create draft co-op"
    Then I should be on the Checklist page
