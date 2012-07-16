Feature: Voting on a resolution
  In order to voice my opinion
  As a Member
  I want to vote on a resolution
  
  Scenario: Member votes on a resolution
    Given there is a co-op
    And I am a Member of the co-op
    And there is a resolution open for electronic voting
    When I go to the Resolutions page
    And I vote to support the resolution
    Then I should see "You voted to support this resolution."
