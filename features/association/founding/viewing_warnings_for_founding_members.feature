Feature: Viewing warnings for Founding Members
  In order to understand my responsibilities
  As a founding member
  I want to view One Click Orgs' warnings for Founding Members

  Scenario: Founding Member views warnings for Founding Members
    Given the application is set up
    And an association has been created
    And I am a founding member
    And the subdomain is the organisation's subdomain
    And I have logged in
    When I follow "Warnings for Founding Members"
    Then I should see One Click Orgs' warnings for Founding Members
