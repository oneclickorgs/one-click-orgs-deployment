Feature: Amending association settings
  In order to make sure the constitution fits our needs
  As a member
  I want to propose amendments to our association's settings
  
  Background:
    Given the application is set up
    And an association is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in
  
  Scenario: Amending association settings
    When I go to the amendments page
    And I fill in the organisation name with "Tea Club Mark II"
    And I fill in the objectives with "REALLY enjoying tea"
    And I choose "Absolute majority" for general decisions
    And I choose "Unanimous" for membership decisions
    And I choose "Simple majority" for constitution decisions
    And I choose "5 minutes"
    And I press "Propose changes"
    Then I should be on the voting and proposals page
    And I should see a proposal "Change organisation name to 'Tea Club Mark II'"
    And I should see a proposal "Change organisation objectives to 'REALLY enjoying tea'"
    And I should see a proposal "Change general voting system to Absolute majority: decisions need supporting votes from more than 50% of members"
    And I should see a proposal "Change membership voting system to Unanimous: decisions need supporting votes from 100% of members"
    And I should see a proposal "Change constitution voting system to Simple majority: decisions need more supporting votes than opposing votes"
    And I should see a proposal "Change voting period to 5 minutes"
