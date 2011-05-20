Feature: Viewing draft organisation details
  In order to decide whether I want to join in founding a draft organisation
  As a founding member
  I want to view details of the draft organisation
  
  Background:
    Given the application is set up
    And an organisation has been created
    And I am a founding member
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Viewing the draft constitution
    When I go to the constitution page
    Then I should see the draft constitution
  
  Scenario: Viewing the list of founding members
    When I go to the members page
    Then I should see the list of founding members
