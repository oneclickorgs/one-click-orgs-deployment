Feature: Setting up an installation
  As an administrator
  I want to set up an installation of One Click Orgs
  So that people can use One Click Orgs
  
  Background:
    Given the application is not set up yet
  
  Scenario: Viewing the domain setup page
    When I go to the home page
    Then I should be on the domain setup page
    And the "base domain" field should contain "www.example.com"
    And the "sign-up domain" field should contain "www.example.com"
  
  Scenario: Choosing domains for the installation
    Given I am on the domain setup page
    When I fill in "base domain" with "example.com"
    And I fill in "sign-up domain" with "create.example.com"
    And I press "Save domains"
    Then I should be on the organisation types page

  Scenario: Choosing multiple organisation types for the installation
    Given I have chosen and saved the domains
    When I choose "Associations" and "Companies Limited by Guarantee" from the organisation types
    And I do not choose "Co-operatives" from the organisation types
    And I submit the organisation types form
    Then I should be on the new organisation page
    And I should see a link to make a new association
    And I should see a link to make a new company
    But I should not see a link to make a new co-operative

  Scenario: Domain is set correctly after completing setup process
    When I go to the domain setup page
    And I have chosen and saved the domains
    And I choose and save the organisation types
    Then the domain should be "create.example.com"
