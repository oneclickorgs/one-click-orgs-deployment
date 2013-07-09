Feature: Being notified of co-op approval
  In order to keep up-to-date with the status of our co-op registration
  As a founder member
  I want to receive an email notification when our co-op is approved

  Scenario: Founder member receives an email notification when their co-op is approved
    Given I am a founder member
    And our co-op has been submitted for approval
    When the co-op is approved
    Then I should receive an email notifying me that the co-op has been approved
