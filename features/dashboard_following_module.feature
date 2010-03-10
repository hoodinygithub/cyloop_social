# http://www.pivotaltracker.com/story/show/372301
Feature: Consumer Private Dashboard - Sidebar - Following module
  As a user viewing my dashboard page,
  I would like to see a list of other users that I follow,
  So that I can navigate to their pages

  Acceptance Criteria:
  - Show in a small thumbnail grid arrangement
  - Show a maximum of 24 thumbnails (8x3)
  - The header should have a view all link which navigates to the "following" tab

  Scenario: Sidebar - Follower module
    Given I am logged in
    And I have 25 friends
    When I go to my dashboard page
    Then I should see 24 followees on the side module
