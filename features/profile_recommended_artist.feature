# http://www.pivotaltracker.com/story/show/372248
Feature: Recommended Artists
  In order to discover new music that I will probably like
  As a user viewing my dashboard page,
  I would like to see some recommended artists,

  Acceptance Criteria:
  - Six artists thumbnails should be shown
  - The recommendations are supplied by the RecEngine based on the user id

  Scenario: Profile page
    Given I am logged in
    And I have activated my account
    And I want to see 6 recommended artists
    When I go to my dashboard page
    Then I should see 6 recommended artists to follow