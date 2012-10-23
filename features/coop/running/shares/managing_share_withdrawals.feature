Feature: Managing share withdrawals
  In order to respond to member's requests for withdrawal of shares
  As the Secretary
  I want to process share withdrawal applications

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  Scenario: Secretary processes a share withdrawal application which has fallen due
    Given a member's share withdrawal application has fallen due
    When the share transaction daily job runs
    And I go to the Shares page
    Then I should see that a share withdrawal application is now due
    When I press "Mark as paid, and cancel shares"
    Then I should see that the member's shareholding has reduced accordingly

  @javascript
  Scenario: Secretary waives the notice period for a new share withdrawal application
    Given there is a share withdrawal application which is not yet due
    When I go to the Shares page
    Then I should see a share withdrawal application which is not yet due
    When I press "Waive the notice period"
    And I certify that the Board has agreed with this
    Then I should see that the member's shareholding has reduced accordingly
