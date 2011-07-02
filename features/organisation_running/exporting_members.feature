Feature: Exporting member data
  As a member
  I want to be able to export my member data

  Background:
    Given the application is set up
    And an organisation is active
    And I am a member of the organisation
    And the subdomain is the organisation's subdomain
    And I have logged in

  Scenario: Downloading a pdf member list
    When I am on the members page
    And I follow "PDF"
    # Blueprint seems to give the same value each time here in cuke
    # tests, but really this shouldn't be hardcoded. Will need a hand on
    # how to set this with blueprint.
    Then I should get a download with the filename "Kunde-Smith Members.pdf"
