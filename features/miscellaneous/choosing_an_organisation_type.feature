Feature: Choosing an organisation type
  In order to start the right kind of organisation for my group
  As a founder
  I want to choose what kind of organisation to create
  
  Background:
    Given the application is set up

  Scenario: Founder views the available types of organisation
    When I go to the home page
    Then I should see a list of types of organisation
  
  Scenario: Founder chooses to create an association
    When I go to the home page
    And I choose to create an association
    Then I should be on the new association page
  
  Scenario: Founder chooses to create a company
    When I go to the home page
    And I choose to create a company
    Then I should be on the new company page
  
  Scenario: Founder chooses to create a co-op
    When I go to the home page
    And I choose to create a co-op
    Then I should be on the co-op intro page
