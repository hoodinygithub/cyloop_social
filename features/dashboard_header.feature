# http://www.pivotaltracker.com/story/show/371940
Feature: Dashboard header
  As logged-in user viewing my dashboard,
  I would like to see my name in the page header
  So that I can know that I'm looking at my dashboard

  Scenario: name
    Given I am logged in
    And my name is "John Doe"
    When I go to my dashboard page
    Then I should see "John Doe"
