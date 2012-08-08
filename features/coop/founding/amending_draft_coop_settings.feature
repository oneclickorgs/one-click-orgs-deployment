Feature: Amending draft coop settings
  In order to make our new co-op work the way we want it to
  As the founder
  I want to amend the settings of the draft co-op

  Scenario: Founder amends the draft co-op's settings
    Given there is a draft co-op
    And I am the founder of the draft co-op
    When I go to the Amendments page
    And I make changes to the rules
    And I save the changes
    Then I should be on the Rules page
    And I should see the changes I made
