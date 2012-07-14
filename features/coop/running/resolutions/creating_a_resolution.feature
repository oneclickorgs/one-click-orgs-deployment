Feature: Creating a resolution
  In order to bring an issue for decision by the Members
  As the Secretary
  I want to create a resolution
  
  Background:
    Given there is a co-op
    And I am the Secretary of the co-op
  
  @javascript
  Scenario: Secretary creates a resolution for electronic voting
    When I go to the Resolutions page
    And I press "Create a new Resolution"
    And I enter the text of the resolution
    And I choose to allow electronic voting on the resolution
    And I certify that the Board has decided to open this resolution
    And I press "Save this resolution"
    Then I should be on the Resolutions page
    And I should see the new resolution in the list of currently-open resolutions
  
  @wip
  Scenario: Secretary creates a resolution for consideration at a future meeting
    When I go to the Resolutions page
    And I press "Create a new Resolution"
    And I enter the text of the resolution
    And I choose to save the resolution for consideration at a future meeting
    And I certify that the Board has decided to open this resolution
    And I press "Save this resolution"
    Then I should be on the Resolutions page
    And I should see the new resolution in the list of draft resolutions
