Feature: Accepting an invitation
  In order to participate in an association
  As an invitee
  I want to accept an invitation to join an association
  
  Background:
    Given the application is set up
    And an association is active
    And I have been invited to join the organisation
  
  @javascript
  Scenario: Accepting an invitation
    Given I have received an email inviting me to become a member
    When I follow the invitation link in the email
    And I fill in "Password" with "letmein"
    And I fill in "Password confirmation" with "letmein"
    And I press "Continue"
    And I press "I accept these terms"
    Then I should be on the welcome page
    And I press "I agree to abide by the constitution"
    Then I should be on the voting and proposals page
