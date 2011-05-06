Feature: Amending draft organisation settings
  In order to make sure the constitution fits our needs
  As a founder
  I want to amend the draft organisation's settings
  
  Background:
    Given the application is set up
    And I have created an organisation
  
  Scenario: Amending draft organisation settings
    When I go to the amendments page
    And I fill in "organisation_name" with "Tea Club Mark II"
    And I fill in "organisation_objectives" with "REALLY enjoying tea"
    And I choose "Absolute majority" for general decisions
    And I choose "Unanimous" for membership decisions
    And I choose "Simple majority" for constitution decisions
    And I choose "5 minutes"
    And I press "Save changes"
    Then I should be on the constitution page
    And I should see "Constitutional changes were made"
    And I should see "Tea Club Mark II"
    And I should see "REALLY enjoying tea"
    And I should see "5 minutes"
    And I should see "A Decision is made if a Proposal receives Supporting Votes from more than half of Members during the Voting Period. "
    And I should see "The Constitution may only be amended by a Decision where Supporting Votes from more than half of the Members are received during the Voting Period; or when more Supporting Votes than Opposing Votes have been received for the Proposal at the end of the Voting Period."
    And I should see "New Members may be appointed (and existing Members ejected) only by a Decision Supporting Votes are received from all Members during the Voting Period."
