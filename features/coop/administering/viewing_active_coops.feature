Feature: Viewing active co-ops
  In order to monitor use of the app
  As an administrator
  I want to view details of active co-ops

  Background:
    Given I am an administrator
    And there are some active co-ops

  Scenario: Administrator views a list of active co-ops
    When I go to the co-op review page
    Then I should see a list of the active co-ops

  @wip
  Scenario: Administrator views details of a active co-op
    When I go to the admin view of an active co-op
    Then I should see the name of the co-op
    And I should see the directors of the co-op
    And I should see the members of the co-op
    And I should see a link to the co-op's rules
