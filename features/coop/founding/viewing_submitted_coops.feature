Feature: Viewing submitted co-ops
  In order to process co-op registrations
  As an administrator
  I want to view the co-ops that have been submitted for registration

  Scenario: Administrator view a list of submitted co-ops
    Given I am an administrator
    And some co-ops have been submitted for registration
    When I go to the co-op review page
    Then I should see a list of the submitted co-ops
