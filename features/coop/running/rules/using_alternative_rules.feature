Feature: Using alternative rules
  In order to allow for new versions of model Rules to be used for new Coops, while keeping old Coops on the original model Rules
  As a sysadmin
  I want to set an individual Coop to use a non-default Rules document

  Scenario: A Coop is set to use an alternative Rules document
    Given there is a Coop
    And there is an alternative model Rules document
    And I am a Member of the Coop
    When the Coop is set to use the alternative model Rules document
    And I go to the Rules page
    Then I should see the alternative Rules

  Scenario: Coops using the default Rules aren't affected by other Coops using alternative Rules
    Given there is a Coop "The Default Coop"
    And there is a Coop "The Alternative Coop"
    And there is an alternative model Rules document
    And I am a Member of the coop "The Default Coop"
    And the Coop "The Alternative Coop" is set to use the alternative model Rules document
    When I go to the Rules page
    Then I should see the default Rules
