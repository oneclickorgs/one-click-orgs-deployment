Feature: Exporting list of Directors
  In order to maintain a paper copy of the list of Directors
  As a Director
  I want to download a PDF version of the list of Directors

  Scenario: Director downloads a PDF version of the list of Directors
    Given there is a co-op
    And I am a Director of the co-op
    When I go to the Directors page
    And I follow "PDF"
    Then I should get a ".pdf" download with the name of the organisation
