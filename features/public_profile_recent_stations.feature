# http://www.pivotaltracker.com/story/show/406683
Feature: Consumer Public Profile Page - Sidebar - Recently Created Stations
  In order to see what my friends are listening to
  As a user visiting another user's page
  I would like to see the list of Statons created by the person I am visiting

  Acceptance Criteria:
  - Same as for dashboard recently created stations

  Scenario: user with stations
    Given a user with 2 stations
    When I go to her page
    Then I should see a "Recently Created Stations" heading

  Scenario: user without stations
    Given a user with 0 stations
    When I go to her page
    Then I should not see a "Recently Created Stations" heading
