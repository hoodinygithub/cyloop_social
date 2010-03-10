# http://www.pivotaltracker.com/story/show/432557
Feature: Consumer Public Profile Page - Header - UnFollow 
  As a user of the site, visiting a Consumers page,
  I would like to be able to unfollow this persons activities

  Acceptance Criteria:
  - must be logged in to invoke this feature
  - should be a link or button that allows me to unfollow the user/artist
  - I should see "Follow" after unfollowing the user/artist
  - I should be already following the user

  Exceptions:
  - Do not show Following button if logged in user is an Artist
  - If anon, invoke /Login page/ once logged in redirect user back to this page.

  Scenario: Unfollowing an artist as a user
    Given I am logged in
    And I am following these artists
      |name   |slug    |started following|
      |Mana   |Mana    |01-02-2008       |
    When I go to Mana's page
    And I click "Following"
    Then I should not be following "Mana"

  Scenario: Unfollowing a user as a user
    Given I am logged in
    And I am following these users
      |name   |slug    |started following|
      |David  |dsalazar|01-02-2008       |
    When I go to David's page
    And I click "Following"
    Then I should not be following "David"
