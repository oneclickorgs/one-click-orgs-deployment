Feature: Dismissing tasks
  In order to keep on top of my tasks
  As the Secretary
  I want to dismiss non-essential tasks from the Dashboard

  @javascript
  Scenario: Secretary dismisses a task
    Given there is a co-op
    And I am the Secretary of the co-op
    And I have a current task
    When I go to the Dashboard
    Then I should see the task
    When I dismiss the task
    Then I should be on the Dashboard
    And I should not see the task
