Feature: Viewing letter of engagement
  In order to prepare our co-op for registration
  As a founder member
  I want to view the Co-operatives UK letter of engagement

  Scenario: Founder Members view the letter of engagement
    Given there is a draft co-op
    And I am a founder member of the draft co-op
    When I go to Documents
    And I follow "Co-operatives UK Letter of Engagement"
    Then I should get a ".pdf" download
