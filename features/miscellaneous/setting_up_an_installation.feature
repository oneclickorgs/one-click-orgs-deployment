Feature: Setting up an installation
  As an administrator
  I want to set up an installation of One Click Orgs
  So that people can use One Click Orgs
  
  Background:
    Given the application is not set up yet
  
  Scenario: Viewing the setup page
    When I go to the home page
    Then I should be on the setup page
    And the "base domain" field should contain "www.example.com"
    And the "sign-up domain" field should contain "www.example.com"
  
  Scenario: Setting up the installation
    Given I am on the setup page
    When I fill in "base domain" with "example.com"
    And I fill in "sign-up domain" with "create.example.com"
    And I press "Save domains"
    Then I should be on the new organisation page
    And the domain should be "create.example.com"
