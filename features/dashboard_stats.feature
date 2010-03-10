# http://www.pivotaltracker.com/story/show/386887
Feature: Dashboard stats
  As a logged-in user viewing my dashboard,
  I would like to see statistics related to my followers and song plays
  So that I can get a sense of my activity on the site

  Scenario: Followers
    Given I am logged in
    And I have 3 followers
    When I go to my dashboard page
    Then I should see "3"
    Then I should see "Followers"

  Scenario: Following
    Given I am logged in
    And I am following 4 users
    When I go to my dashboard page
    Then I should see "4"
    Then I should see "Following"

#  Scenario: Song plays
#    Given I am logged in
#    And I have played 5 songs
#    When I go to my dashboard page
#    Then I should see "5 Song Plays"

  Scenario: Clicking Followers count should take you to followers page
    Given I am logged in
    And I have 3 followers
    When I go to my dashboard page
    And I click on my "3" "followers" stats count
    Then I should be on my followers page

  Scenario: Clicking Following count should take you to followings page
    Given I am logged in
    When I go to my dashboard page
    And I click on my "4" "following" stats count
    Then I should be on my following index page

  Scenario: Clicking Following count should take you to charts page (songs tab)
    Given I am logged in
    When I go to my dashboard page
    And I click on my "5" "song plays" stats count
    Then I should be on my charts songs page
