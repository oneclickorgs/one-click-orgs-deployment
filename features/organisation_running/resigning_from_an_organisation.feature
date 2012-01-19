Feature: Resigning from a an organisation
  In order to leave an organisation formally
  As a member
  I want to be able to resign from my positions inside it.

  Background:
    Given the application is set up
    And an organisation is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in

  @wip
  Scenario: Resigning
    Given there is a member "bob@example.com"
    When I go to my member page
    And I click on the resign link, and confirm my leaving
    Then I should be logged out, with a message telling me I have resigned.
  
  @wip
  Scenario: Being notified of another member's resignation
    Given another member has resigned
    Then I should receive an email saying that member has resigned
  
  @wip
  Scenario: Seeing a resignation in the timeline
    Given another member has resigned
    When I go to the dashboard
    Then I should see the resignation in the timeline