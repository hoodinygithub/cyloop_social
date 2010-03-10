# http://www.pivotaltracker.com/story/show/406298
Feature: Consumer Public Profile Page - Sidebar - Following
  As a user of the site, visiting a Consumers page,
  I would like to see the list of Consumers they recently started to follow

  Acceptance Criteria:
  - Show in a small thumbnail grid arrangement
  - Show a maximum of 24 thumbnails (8x3)
  - The header should have a view all link which navigates to the "following" tab
  
  Scenario: Sidebar - Follower module
    Given I am logged in
    And the following user
      |name          |
      |Jason Calleiro|
    And Jason Calleiro follows 25 users
    When I go to Jason Calleiro's page
    Then I should see 24 followees on the side module
