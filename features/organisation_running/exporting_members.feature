Feature: Exporting member data
  As a member
  I want to be able to export my member data

  Background:
    Given the application is set up
    And an organisation is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in

  Scenario: Downloading a pdf member list
    When I am on the members page
    And I follow "PDF"
    Then I should get a ".pdf" download with the name of the organisation

  Scenario: Downloading a csv member list
    When I am on the members page
    And I follow "CSV"
    Then I should get a ".csv" download with the name of the organisation
