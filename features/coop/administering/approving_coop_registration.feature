Feature: Approving co-op registration
  In order to allow a co-op to progress
  As an administrator
  I want approve a co-op registration

  Background:
    Given I am an administrator

  Scenario: Administrator receives an email notification of a new draft co-op
    When a draft co-op is created
    Then I should receive an email notifying me about the new draft co-op

  Scenario: Administrator receives an email notification of a co-op submitted for registration
    When a draft co-op is submitted for registration
    Then I should receive an email notifying me that the co-op has been submitted for registration

  Scenario: Administrator approves a co-op registration
    Given a co-op has been submitted
    When I go to the co-op review page
    And I follow "View full information" for the co-op
    And I press "Mark this co-op as fully registered"
    Then I should see that the co-op is approved
