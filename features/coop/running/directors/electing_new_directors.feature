Feature: Electing new directors
  In order to have a say in who runs the co-op
  As a Member
  I want to vote for new Directors electronically
  
  @wip
  Scenario: Member votes for new Directors electronically
    Given there is an electronic vote for new directors in progress
    When I place my vote for the new directors I want
    Then my vote should be counted
