Feature: Authorisation
  Members should have the correct levels of authorisation.
  
  Background:
    Given the application is set up
    And a company has been added
    And I am a director of the company
    And there are two other directors of the company
    And the subdomain is the organisation's subdomain
  
  Scenario: Stood-down director should not be able to log in
    Given I have been stood down
    When I try to log in
    Then I should not be logged in
