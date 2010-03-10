# http://www.pivotaltracker.com/story/show/376913
Feature: Dashboard - Stations page 
  In order to view and/or manage my stations
  As a user
  I want to access my Stations page

  Acceptance criteria:
  - In private view, show Stations tab with editing capabilities (RUD)

  Scenario: Visiting the profile stations page for a user
    Given a user with 2 stations
    When I go to her stations page
    Then I should see a list of stations

  Scenario: Edit station name
    Given I am logged in
    And I have a station named "Brown"
    When I go to my stations page
    And I click edit for station "Brown"
    And I fill in "user_station[name]" with "Nin"
    And I click "save"
    Then I should see "Nin" 
    
  Scenario: Delete station
    Given I am logged in
    And I have 10 stations
    When I go to my stations page
    And I delete a station
    Then I should have 9 stations
