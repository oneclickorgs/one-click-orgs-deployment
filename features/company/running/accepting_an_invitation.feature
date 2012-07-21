Feature: Accepting an invitation
  In order to participate in company
  As a new director
  I want to accept an invitation to sign up
  
  Background:
    Given the application is set up
    And a company has been added
    And I have been invited to sign up as a director
  
  @javascript
  Scenario: Accepting an invitation
    Given I have received an email inviting me to sign up as a director
    When I follow the invitation link in the email
    And I fill in "Password" with "letmein"
    And I fill in "Password confirmation" with "letmein"
    And I press "Continue"
    And I press "I accept these terms"
    Then I should be on the Votes & Minutes page
