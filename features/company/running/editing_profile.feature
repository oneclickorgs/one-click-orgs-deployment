Feature: Editing profile
  In order to keep my details up to date
  As a director
  I want to edit my profile
  
  Background:
  Given the application is set up
  And a company has been added
  And the company has directors
  And I am a director of the company
  And the subdomain is the organisation's subdomain
  And I have logged in
  
  Scenario: Editing profile
    When I go to the home page
    And I follow "Edit your account"
    And I fill in "First name" with "Nouveau"
    And I fill in "Last name" with "Atarashii"
    And I fill in "Email" with "nouveau@example.com"
    And I press "Save changes"
    Then I should see "Account updated"
    And I should see "Nouveau Atarashii"
    And my email should be "nouveau@example.com"
