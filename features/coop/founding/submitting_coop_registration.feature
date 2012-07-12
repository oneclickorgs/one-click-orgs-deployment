Feature: Submitting co-op registration
  In order to make our co-op official
  As the founder
  I want to submit the registration for our draft co-op
  
  @wip
  Scenario: Founder submits co-op registration
    Given there is a draft co-op
    And I am the founder of the draft co-op
    When I submit the registration for our co-op
    Then our co-op should be registered
