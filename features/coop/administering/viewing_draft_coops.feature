Feature: Viewing draft co-ops
  In order to monitor incoming co-op registrations
  As an administrator
  I want to view details of draft co-ops

  Background:
    Given I am an administrator
    And some draft co-ops have been created

  Scenario: Administrator views a list of draft co-ops
    When I go to the co-op review page
    Then I should see a list of the draft co-ops

  @wip
  Scenario: Administrator views details of a proposed co-op
    When I go to the admin view of a draft co-op
    Then I should see the name of the co-op
    And I should see the founder members of the co-op
    And I should see a link to the co-op's rules
    And I should see a link to the co-op's registration form
    And I should see a link to the co-op's anti-money laundering form
