Feature: Approving co-op registration
  In order to allow a co-op to progress
  As an administrator
  I want approve a co-op registration

  Scenario: Administrator approves a co-op registration
    Given I am an administrator
    And a co-op has been submitted
    When I go to the co-op review page
    And I press "Approve" for the co-op
    Then I should see that the co-op is approved
