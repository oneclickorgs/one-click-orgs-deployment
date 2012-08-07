Feature: Suggesting rules amendments
  In order to change the way the co-op works
  As a Member
  I want to suggest resolutions that change the Rules of the Co-op

  @javascript
  Scenario: Member suggests draft resolutions to amend the Rules
    Given there is a co-op
    And I am a Member of the co-op
    When I go to the Rules page
    And I press "Suggest amendments to the Rules"
    And I change the Name to "The Tea Co-op"
    And I change the Registered office address to "1 Main Street"
    And I change the Objects to "buy all the tea."
    And I choose to allow "User" members
    And I choose to allow "Employee" members
    And I choose to disallow "Supporter" members
    And I choose to disallow "Producer" members
    And I choose to disallow "Consumer" members
    And I choose that Members hold one share only
    And I enter "2" for each of the Board composition fields
    And I choose Common Ownership
    And I press "Suggest these amendments"
    Then I should be on the Resolutions page
    And I should see a suggested resolution "Change organisation name to 'The Tea Co-op'"
    And I should see a suggested resolution "Change registered office address to '1 Main Street'"
    And I should see a suggested resolution "Change objects to 'buy all the tea.'"
    And I should see a suggested resolution "Change the Rules to disallow Supporter Members"
    And I should see a suggested resolution "Change the Rules to disallow Producer Members"
    And I should see a suggested resolution "Change the Rules to disallow Consumer Members"
    And I should see a suggested resolution "Change the Rules to permit each Member to hold only one share"
    And I should see a suggested resolution "Allow a maximum of 2 User Members on the Board"
    And I should see a suggested resolution "Allow a maximum of 2 Employee Members on the Board"
    And I should see a suggested resolution "Change the organisation to be a Common Ownership enterprise"
