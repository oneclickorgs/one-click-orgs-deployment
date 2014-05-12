Feature: Managing draft and suggested resolutions
  In order to bring resolutions up for consideration
  As the Secretary
  I want to deal with draft resolutions and suggested resolutions

  Background:
    Given there is a co-op
    And I am the Secretary of the co-op

  Scenario: Secretary receives a task when a resolution is suggested
    Given there is a suggested resolution
    When I go to the Dashboard
    Then I should see a task telling me to deal with the suggested resolution

  Scenario: Secretary opens a draft resolution for electronic voting
    Given there is a draft resolution
    When I go to the Resolutions page
    And I press "Start an electronic vote" for the draft resolution
    Then I should see the resolution in the list of currently-open resolutions

  Scenario: Secretary adds a draft resolution to a meeting
    Given there is a draft resolution
    When I go to the Resolutions page
    And I press "Add to a meeting" for the draft resolution
    Then I should be on the "Convene a General Meeting" page
    And I should see the resolution in the list of resolutions to be considered at the meeting

  Scenario: Secretary edits a suggested resolution
    Given there is a suggested resolution
    When I go to the Resolutions page
    And I press "Edit" for the suggested resolution
    And I amend the text of the resolution
    And I save the resolution
    Then I should see the amended resolution text in the list of suggested resolutions

  Scenario: Secretary opens a suggested resolution for electronic voting
    Given there is a suggested resolution
    When I go to the Resolutions page
    And I press "Start an electronic vote" for the suggested resolution
    Then I should see the resolution in the list of currently-open resolutions
    And I should not see the suggested resolution in the list of suggested resolutions
    When I go to the Dashboard
    Then I should not see a notification to process the suggested resolution

  Scenario: Secretary adds a suggested resolution to a meeting
    Given there is a suggested resolution
    When I go to the Resolutions page
    And I press "Add to a meeting" for the suggested resolution
    Then I should be on the "Convene a General Meeting" page
    And I should see the resolution in the list of resolutions to be considered at the meeting
