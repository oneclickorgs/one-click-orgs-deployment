Feature: Submitting co-op registration
  In order to make our co-op official
  As the founder
  I want to submit the registration for our draft co-op

  Scenario: Founder submits co-op registration
    Given there is a draft co-op
    And I am the founder of the draft co-op
    And the requirements for registration have been fulfilled
    When I submit the registration for our co-op
    Then I should see that our registration has been submitted
