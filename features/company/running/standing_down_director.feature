Feature: Standing down director
  In order to reflect changes in directorship
  As a director
  I want to stand down a director
  
  Background:
    Given the application is set up
    And a company has been added
    And I am a director of the company
    And there are two other directors of the company
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Directors stands down another director
    Given I am on the Directors page
    When I press "Stand down" for another director
    Then I should see a form for standing down the director
    When I submit the form to stand down the director
    Then I should be on the Directors page
    And I should not see the director
  
  Scenario: Directors are notified of a director standing down
    When I stand down a director
    Then all the directors should receive a "stood down" email
