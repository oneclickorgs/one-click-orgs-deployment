Feature: Editing money laundering form
  In order to prepare our co-op for registration
  As a founder member
  I want to edit the money laundering form

  Background:
    Given there is a draft co-op
    And I am a founder member of the draft co-op
    And there are at least two directors

  Scenario: Founder member enters the main contact info for Co-operatives UK
    When I go to edit the registration details
    And I enter the main contact info
    And I save the registration details
    Then I should see the main contact info

  Scenario: Founder member enters the financial contact info for Co-operatives UK
    When I go to edit the registration details
    And I enter the financial contact info
    And I save the registration details
    Then I should see the financial contact info

  Scenario: Founder member enters details for the money laundering contacts
    When I go to edit the registration details
    And I enter details for the two money laundering contacts
    And I save the registration details
    Then I should see the details for the two money laundering contacts

  Scenario: Founder member confirms agreement with the letter of engagement and money laundering form
    When I go to edit the registration details
    And I check "I have read and agree to the Letter of Engagement and Anti-Money Laundering requirements."
    And I save the registration details
    Then I should see the agreement checkbox is checked
