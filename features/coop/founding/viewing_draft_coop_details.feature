Feature: Viewing draft coop details
  In order to understand the co-op we are drafting
  As a founding member
  I want to view the details of the draft co-op
  
  # Background:
  #   Given there is a draft co-op
  #   And I am a founding member of the draft co-op
  
  @wip
  Scenario: Founding member views the rules of the draft co-op
    When I go to the Rules page
    Then I should see the rules of the draft co-op
    And I should see the customisations we have made to the rules
  
  @wip
  Scenario: Founding member views the members of the draft co-op
    When I go to the Members page
    Then I should see a list of founding members of the draft co-op
  
  @wip
  Scenario: Founding member views the directors and officers of the draft co-op
    When I go to the Directors page
    Then I should see a list of the directors of the draft co-op
    And I should see a list of officers of the draft co-op
