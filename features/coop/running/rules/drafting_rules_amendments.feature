Feature: Drafting rules amendments
  In order to change the way the co-op works
  As the Secretary
  I want to record resolutions that change the Rules of the Co-op

  @javascript
  Scenario: Secretary creates draft resolutions to amend the Rules
    Given there is a co-op
    And I am the Secretary of the co-op
    When I go to the Rules page
    And I press "Amend the Rules"
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
    And I press "Create draft resolutions"
    Then I should be on the Resolutions page
    And I should see a draft resolution "Change organisation name to 'The Tea Co-op'"
    And I should see a draft resolution "Change registered office address to '1 Main Street'"
    And I should see a draft resolution "Change objects to 'buy all the tea.'"
    And I should see a draft resolution "Change the Rules to disallow Supporter Members"
    And I should see a draft resolution "Change the Rules to disallow Producer Members"
    And I should see a draft resolution "Change the Rules to disallow Consumer Members"
    And I should see a draft resolution "Change the Rules to permit each Member to hold only one share"
    And I should see a draft resolution "Allow a maximum of 2 User Members on the Board"
    And I should see a draft resolution "Allow a maximum of 2 Employee Members on the Board"
    And I should see a draft resolution "Change the organisation to be a Common Ownership enterprise"
