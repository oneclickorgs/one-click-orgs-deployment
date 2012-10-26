Feature: Withdrawing shares
  In order to reduce my investment in the co-op
  As a Member
  I want to make an application to withdraw some shares

  Background:
    Given there is a co-op
    And members of the co-op can hold more than one share
    And I am a Member of the co-op

  @javascript
  Scenario: Member withdraws some of their shares
    Given I hold more shares than the minimum shareholding
    When I go to the Shares page
    And I press "Withdraw shares"
    And I choose to withdraw a number of shares which will still leave me with the minimum shareholding
    And I press "Apply to withdraw shares"
    Then I should see that my withdrawal application has been received
    And the Secretary should receive a notification of the share withdrawal application

  # @wip @javascript
  # Scenario: Member withdraws all of their shares
  #   Given I hold only the minimum shareholding
  #   When I go to the Shares page
  #   And I press "Withdraw shares"
  #   And I choose to withdraw all my shares
  #   Then I should see a notice that this withdrawal will terminate my membership
  #   When I confirm that I want to terminate my membership
  #   And I press "Apply for share withdrawal"
  #   Then I should see that my withdrawal application has been received
  #   And the Secretary should receive a notification of the share withdrawal application
