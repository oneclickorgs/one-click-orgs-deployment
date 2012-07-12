Feature: Resigning membership
  In order to end my relationship with the co-op
  As a Member
  I want to resign my membership
  
  @wip
  Scenario: Member resigns their membership
    Given there is a co-op
    And I am a Member of the co-op
    When I go to my profile page
    And I press "Resign my membership"
    And I confirm that I want to resign
    Then I should see "You have resigned"
    And the Secretary should receive a notification of my resignation
