Feature: Show notification once
  Notifications like the 'convener_welcome' should only be shown once.
  
  Scenario: Convener welcome is only shown once
    Given the application is set up
    When I create an organisation
    Then I should see "Now you can read the constitution"
    When I go to the members page
    Then I should not see "Now you can read the constitution"
