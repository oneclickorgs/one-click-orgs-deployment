Feature: Editing profile
  In order to keep my details up to date
  As a member
  I want to edit my profile
  
  Background:
    Given the application is set up
    And an organisation is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Editing profile
    When I go to the home page
    And I follow "Edit your account"
    And I fill in "First name" with "Nouveau"
    And I fill in "Last name" with "Atarashii"
    And I fill in "Email" with "nouveau@example.com"
    And I fill in "Role" with "Secretary"
    And I press "Save changes"
    Then I should see "Account updated"
    And I should see "Nouveau Atarashii"
    And I should see "nouveau@example.com"
    And I should see "Secretary"
