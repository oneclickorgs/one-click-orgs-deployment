Feature: Applying for membership
  In order to become part of the co-op
  As an applicant
  I want to apply for membership of the co-op
  
  Scenario: Applicant applies for membership
    Given there is a co-op
    When I go to the home page
    And I follow "Apply for membership"
    And I fill in my details
    And I apply for the necessary number of shares
    And I certify that I am aged 16 years or over
    And I press "Send membership application"
    Then I should see "Your membership application has been received."
    And the Secretary should receive a notification of the new membership application
