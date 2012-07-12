Feature: Terminating membership
  In order to deal with a member who must cease to be a member of the co-op
  As the Secretary
  I want to terminate their membership
  
  @wip
  Scenario: Secretary terminates a membership
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is a Member whose membership needs to be terminated
    When I go to the member's profile page
    And I press "Terminate membership"
    And I confirm the termination of their membership
    Then I should see "membership has been terminated"
