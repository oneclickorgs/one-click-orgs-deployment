Feature: Terminating membership
  In order to deal with a member who must cease to be a member of the co-op
  As the Secretary
  I want to terminate their membership

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op
    And there is a Member whose membership needs to be terminated

  Scenario: Secretary terminates a membership
    When I go to the member's profile page
    And I follow "Terminate membership"
    And I confirm the termination of their membership
    Then I should see "membership has been terminated"

  Scenario: Shares are cancelled on termination of membership
    Given members of the co-op can hold more than one share
    And the member has several shares
    When I note the total number of shares currently issued
    And I note the number of shares the member has
    And I terminate the member
    Then I should see that the total number of issued shares has reduced by the number of shares the member had
