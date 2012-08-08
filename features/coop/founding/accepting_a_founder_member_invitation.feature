Feature: Accepting a Founder Member invitation
  In order to become part of a new co-op
  As someone who has been invited to join a new co-op
  I want to accept the invitation

  Scenario: Invitee accepts invitation to become a Founder Member
    Given there is a draft co-op
    And I have received an invitation to become a Founder Member of the draft co-op
    When I follow the link in the email
    And I enter my details
    And I press "Continue"
    Then I should be on the dashboard for the draft co-op
    And I should be a Founder Member of the draft co-op
