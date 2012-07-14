Feature: Applying for membership
  In order to become part of the co-op
  As an applicant
  I want to apply for membership of the co-op
  
  @wip
  Scenario: Applicant applies for membership
    Given there is a co-op
    When I go to the home page
    And I follow "Apply for membership"
    And I fill in my details
    And I apply for the necessary number of shares
    Then I should see "Your membership application has been received."
    And the Secretary should receive a notification of the new membership application
