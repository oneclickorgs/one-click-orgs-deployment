Feature: Viewing a resolution
  In order to participate in the decision-making process
  As a member
  I want to view resolutions of different kinds

  Background:
    Given there is a co-op
    And I am a Member of the co-op

  Scenario: Member views their suggested resolution
    Given I have suggested a resolution
    When I go to the Resolutions page
    Then I should see the suggested resolution in the list of my suggestions
    When I view more details of the suggested resolution
    Then I should not see voting UI
