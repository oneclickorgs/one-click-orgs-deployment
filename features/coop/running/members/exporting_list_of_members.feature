Feature: Exporting list of members
  In order to maintain a paper copy of the list of members
  As a director
  I want to download a PDF version of the list of members

  Scenario: Director downloads a PDF version of the list of members
    Given there is a co-op
    And I am a Director of the co-op
    When I go to the Members page
    And I follow "PDF"
    Then I should get a ".pdf" download with the name of the organisation
