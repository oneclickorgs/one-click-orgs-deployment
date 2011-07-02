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
    # Blueprint always gives the first values from Faker
    # name calls - https://github.com/notahat/machinist/issues/22
    # This for this reason, we can use Kunde-Smith for the Organisation Name
    Then I should get a download with the filename "Kunde-Smith Members.pdf"

  Scenario: Downloading a csv member list
    When I am on the members page
    And I follow "CSV"
    Then I should get a download with the filename "Kunde-Smith Members.csv"
