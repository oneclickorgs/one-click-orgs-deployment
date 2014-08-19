Feature: Applying for shares
  In order to increase my investment in the co-op
  As a Member
  I want to apply for more shares

  Background:
    Given there is a co-op
    And members of the co-op can hold more than one share
    And I am a Member of the co-op

  @javascript
  Scenario: Member applies for more shares
    When I go to the Shares page
    And I press "Apply for more shares"
    And I enter the number of additional shares I want
    Then I should see the payment that will be required
    When I press "Apply for more shares"
    Then I should see that a payment is required for my new shares
    And the Secretary should receive a notification of the new share application

  @javascript
  Scenario: Member applies for shares that would take them over the maximum legal shareholding
    When I go to the Shares page
    And I press "Apply for more shares"
    And I enter a number of additional shares that would take me over the maximum legal shareholding
    Then I should see a message telling me that I cannot apply for this number of shares
    And I should not be able to press "Apply for more shares"
