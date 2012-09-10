Feature: Suggesting a resolution
  In order to bring an issue up with the membership
  As a member
  I want to suggest a resolution for consideration
  
  @javascript
  Scenario: Member suggests a resolution
    Given there is a co-op
    And I am a Member of the co-op
    When I go to the Resolutions page
    And I press "Suggest a new Resolution"
    And I enter the text for the new resolution
    And I press "Save this resolution"
    Then I should be on the Resolutions page
    And the Secretary should receive a notification of the new suggested resolution
