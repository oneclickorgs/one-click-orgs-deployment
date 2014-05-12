Feature: Viewing stats
  In order to learn about usage of the instance
  As an administrator
  I want to view stats about the users

Background:
  Given I am an administrator
  And there are some members

Scenario: Administrator views a list of all users
  When I go to the administrator's users page
  Then I should see a list of all the users

Scenario: Administrator views a list of users from active co-ops
  When I go to the administrator's users page
  And I follow "Active organisations"
  Then I should see a list of all the users in active organisations
  And I should not see any users from draft organisations
  And I should not see any users from proposed organisations

Scenario: Administrator views a list of users from proposed co-ops
  When I go to the administrator's users page
  And I follow "Organisations awaiting registration"
  Then I should see a list of all the users in proposed organisations
  And I should not see any users from draft organisations
  And I should not see any users from active organisations
