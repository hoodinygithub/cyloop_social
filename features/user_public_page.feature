# http://www.pivotaltracker.com/story/show/370339
Feature: User (Public) Page
  So that visitors to the site can see stuff about another user
  As a user
  I want to be able to view someone else's profile

  Scenario: Visiting a public user profile page
    Given the following users
      |name    |slug |
      |Foo Bar |foo  |
    When I go to Foo Bar's page
    Then I should see a "Foo Bar" heading
