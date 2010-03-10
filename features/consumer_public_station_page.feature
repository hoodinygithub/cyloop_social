# http://www.pivotaltracker.com/story/show/407820
Feature: Consumer Public - Stations page - List view
  As a user of the site, visiting a Consumers page,
  I would like to see the summary of all the statons created by the person I am visiting

  Acceptance Criteria:
  - Header reads "STATIONS"
  - Sub-text reads "Last Station Created On: [Date]"
  - Right aligned: Value: Count of total stations
  - Sub header reads: "View: All 

  -List all stations sorted by created date descending

  -line item contents include:
  - Radio tower photo (60x60)
  - Station name
  - Created on [Date/tme]

  Actions:
  -Play icon - redirects user to the Radio  page with Station seeded
  -Share icon - invokes the share layer

  Scenario: I should not see Edit or Delete
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And user jcalleiro has 2 stations
    When I go to Jason Calleiro's stations page
    Then I should not see "Edit"
    And I should not see "Delete"

  Scenario: Visiting the profile stations page for a user
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And user jcalleiro has 2 stations
    When I go to Jason Calleiro's stations page
    Then I should see a list of stations

  Scenario: I want to see stations sub header
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And user jcalleiro has 2 stations 
    When I go to Jason Calleiro's stations page
    Then I should see a "Jason Calleiro's Stations" heading
    And I should see "Created less than a minute ago"
    And I should see "2"
   And I should see "Stations"
    And I should see a view "Stations" filter 
