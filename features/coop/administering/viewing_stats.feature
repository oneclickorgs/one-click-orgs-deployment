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
