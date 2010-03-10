# http://www.pivotaltracker.com/story/show/427410
Feature: Dashboard UI - Main Tabs
  As a user viewing my dashboard page,
  I should see the following s

  Acceptance Requirements
  -Dashboard
  -Playlists
  -Stations
  -Following
  -Charts
  -Settings

  Scenario: Dashboard
    Given I am logged in
    And I am on my dashboard page
    When I click "Dashboard"
    Then I should be on my dashboard page

  Scenario: Playlists
    Given I am logged in
    And I am on my dashboard page
    When I click "Playlists"
    Then I should be on my playlists page

  Scenario: Stations
    Given I am logged in
    Given I have 10 stations
    And I am on my dashboard page
    When I click "Stations"
    Then I should be on my stations page

  Scenario: Community
    Given I am logged in
    And I am on my dashboard page
    When I click "Community"
    Then I should be on my following index page

  Scenario: Charts
    Given I am logged in
    And I am on my dashboard page
    When I click "Charts"
    Then I should be on my charts songs page

  Scenario: Settings
    Given I am logged in
    And I am on my dashboard page
    When I click "Settings"
    Then I should be on the edit my settings page
