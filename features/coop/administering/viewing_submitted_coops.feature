Feature: Viewing submitted co-ops
  In order to process co-op registrations
  As an administrator
  I want to view the co-ops that have been submitted for registration

  Background:
    Given I am an administrator
    And some co-ops have been submitted for registration

  Scenario: Administrator view a list of submitted co-ops
    When I go to the co-op review page
    Then I should see a list of the submitted co-ops

  Scenario: Administrator views details of a proposed co-op
    When I go to the admin view of a proposed co-op
    Then I should see the name of the co-op
    And I should see the founder members of the co-op
    And I should see a link to the co-op's rules
    And I should see a link to the co-op's registration form

  Scenario: Administrator downloads a PDF of a proposed co-op's rules
    When I go to the admin view of a proposed co-op
    And I follow "Download rules"
    Then I should get a ".pdf" download

  Scenario: Administrator downloads a PDF of a proposed co-op's registration form
    When I go to the admin view of a proposed co-op
    And I follow "Download registration form"
    Then I should get a ".pdf" download

  Scenario: Administrator downloads a PDF of a proposed co-op's anti-money laundering form
    When I go to the admin view of a proposed co-op
    And I follow "Download anti-money laundering form"
    Then I should get a ".pdf" download
