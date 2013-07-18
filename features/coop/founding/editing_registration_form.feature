Feature: Editing registration form
  In order to prepare our co-op for registration
  As a founder member
  I want to edit the registration form

  Scenario: Founder member chooses three signatories
    Given there is a draft co-op
    And I am the founder of the draft co-op
    And there are at least three founder members
    When I go to edit the registration form
    And I choose three signatories
    And I save the registration form
    When I go to the checklist
    Then I should see that the registration form is done
