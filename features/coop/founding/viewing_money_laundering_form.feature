Feature: Viewing money laundering form
  In order to prepare our co-op for registration
  As a founder member
  I want to view the Co-operatives UK money laundering form

  Scenario: Founder member views the money laundering form
    Given there is a draft co-op
    And I am a founder member of the draft co-op
    And the money laundering form has been filled in
    When I go to Documents
    And I follow "Co-operatives UK Anti-Money Laundering Form"
    Then I should get a ".pdf" download
