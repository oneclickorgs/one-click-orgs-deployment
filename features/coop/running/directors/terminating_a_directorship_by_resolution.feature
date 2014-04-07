Feature: Terminating a directorship by resolution
  In order to terminate a directorship
  As the secretary
  I want to draft a resolution to terminate a directorship

  @javascript
  Scenario: Secretary drafts a resolution to terminate a directorship
    Given there is a co-op
    And I am the secretary of the co-op
    And there is a director named "Bob Smith"
    When I go to create a new resolution
    And I select "Terminate a director's appointment" from "Type of proposal"
    And I select "Bob Smith" from "Director"
    And I press "Save this proposal as a draft"
    Then I should see a draft resolution "Terminate Bob Smith's appointment as a director"

  Scenario: A resolution to terminate a directorship is enacted
    Given there is a co-op
    And I am the secretary of the co-op
    And there is a director named "Bob Smith"
    And a resolution to terminate the directorship of "Bob Smith" has been attached to a past General Meeting
    When I go to minute the General Meeting
    And I mark that the resolution "Terminate Bob Smith's appointment as a director" was passed
    And I save the minutes
    And I go to the Directors page
    Then I should not see "Bob Smith" in the list of directors
