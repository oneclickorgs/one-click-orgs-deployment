Feature: Editing submitted co-ops
  In order to ensure that co-ops are set up properly for registration
  As an administrator
  I want to edit the details of submitted co-ops

  Background:
    Given I am an administrator
    And some co-ops have been submitted for registration

  Scenario: Administrator edits a submitted co-op's Rules
    When I go to the admin view of a proposed co-op
    And I follow "Edit Rules"
    And I make changes to the rules
    And I save the changes
    And I follow "View rules"
    Then I should see the changes I made

  @wip
  Scenario: Administrator edits a submitted co-op's registration form
    When I go to the admin view of a proposed co-op
    And I follow "Edit registration details"
    And I fill in the close links field with "There are no close links."
    And I save the changes
    And I follow "Download registration form"
    Then the PDF should contain "There are no close links."

  @wip
  Scenario: Administrator edits a submitted co-op's anti-money laundering form
    When I go to the admin view of a proposed co-op
    And I follow "Edit registration details"
    And I fill in the finance contact field with "Milburn Pennybags"
    And I save the changes
    And I follow "View anti-money laundering form"
    Then I should see "Milburn Pennybags"
