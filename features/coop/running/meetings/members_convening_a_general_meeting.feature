Feature: Members convening a general meeting
  In order to ensure some issues are discussed
  As a member
  I want to convene a general meeting

  Scenario: Member creates an application to convene a general meeting
    Given there is a co-op
    And I am a member of the co-op
    When I go to the Meetings page
    And I follow "Apply to convene a General Meeting"
    And I enter the purpose of the meeting
    And I press "Next"
    Then I should see a special link to share the application

  Scenario: Member supports an application to convene a general meeting
    Given there is a co-op
    And I am a member of the co-op
    And another member has created an application to convene a general meeting
    When I visit the special link for the general meeting application
    Then I should see the purpose of the meeting
    And I should see the name of the member who created the application
    When I press "I support this application to convene a general meeting"
    Then I should see that I have signed the general meeting application

  Scenario: Secretary is notified when an application to convene a general meeting has reached sufficient signatures
    Given there is a co-op
    And I am the secretary of the co-op
    And an application to convene a general meeting has been created
    When the general meeting application has reached sufficient signatures
    And the proposal closer runs
    And I go to the dashboard
    Then I should see a notification of the general meeting application
    When I follow the link to view more details about the general meeting application
    Then I should see the purpose of the general meeting
    And I should see the names of the members who signed the general meeting application
