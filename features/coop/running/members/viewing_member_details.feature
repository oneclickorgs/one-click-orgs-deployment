Feature: Viewing member details
  In order to check records of the members
  As a Member
  I want to view the details of a particular member
  
  @wip
  Scenario: Member views another member's details
    Given there is a co-op
    And I am a Member of the co-op
    When I go to another member's profile page
    Then I should see the details of that member's profile
