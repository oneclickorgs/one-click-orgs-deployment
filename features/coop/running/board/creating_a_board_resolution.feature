Feature: Creating a board resolution
  In order to initiate a decision of the Board
  As a Director
  I want to create a resolution of the board

  Background:
    Given there is a co-op
    And I am a Director of the co-op

  Scenario: Director creates a board resolution to be voted on electronically
    When I go to the Board page
    And I press "Create a new Board Resolution"
    And I enter the text of the new resolution
    And I choose to open the resolution for electronic voting
    And I press "Save this resolution"
    Then I should be on the Board page
    And I should see the new resolution in the list of currently-open resolutions
    And the new resolution should have voting buttons

  Scenario: Director creates a board resolution to be be considered at a future meeting
    When I go to the Board page
    And I press "Create a new Board Resolution"
    And I enter the text of the new resolution
    And I choose to save the resolution for consideration at a future meeting of the board
    And I press "Save this resolution"
    Then I should be on the Board page
    And I should see the new resolution in the list of draft resolutions
