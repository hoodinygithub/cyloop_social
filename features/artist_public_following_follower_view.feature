# http://www.pivotaltracker.com/story/show/435313
@artist_public
Feature: Artist Public - Following page - Followers view
  As a user of the site, visiting an artists page,
  I would like to see a list of people that are following the 
  artist so that I can see who are fans of the artist I am interested in

  Acceptance Criteria:
  - Module header reads "FOLLOWERS"
  - Right-aligned Count of people this Artist is following
  - Sub-header reads "Filter by: Followers.
  - Followers view is selected
  - Initial view shows the top 15 following ordered by date of follow action descending
  - Pagination links at the bottom

  Line item contents include:
  - Users Profile photo (60x60) - hyperlinked to profile
  - User name - hyperlinked to profile
  - Users Location: [Artist City, State]

  If logged in, visitor can elect to Follow anyone from the Follower views. 
  If visitor is already following a person, then state should read 
  "Following" otherwise read "Follow"
  If not logged in, anon, then redirect user to the login flow

  Actions:
  -Follow button changes state to Following and vice versa
  -Dynamic test to determine if visitor is currently following any of the same people

  Scenario: I want to see the users that are following the artist
    Given I am logged in
    And I am following these users
      | name | slug | started following |
      | John | jdoe | 2007-08-31        |
    And the following user
      | name           | slug      | short_bio        | born_on    | websites                   |
      | Jason Calleiro | jcalleiro | Waaa I'm a slore | 1980-06-03 | www.facebook.com/jcalleiro |
    And user jcalleiro is following these artists
      | name | slug | started following |
      | Mana | mana | 2007-08-31        |
    When I go to Mana's followers page
    Then I should see "Jason Calleiro"

  Scenario: I want to follow the users that are following the artist
    Given I am logged in
    And I am following these users
      | name | slug | started following |
      | John | jdoe | 2007-08-31        |
    And the following user
      | name           | slug      | short_bio        | born_on    | websites                   |
      | Jason Calleiro | jcalleiro | Waaa I'm a slore | 1980-06-03 | www.facebook.com/jcalleiro |
    And user jcalleiro is following these artists
      | name | slug | started following |
      | Mana | mana | 2007-08-31        |
    When I go to Mana's followers page
    Then I should see "Jason Calleiro"
    And for "Jason Calleiro" I click "Follow"
    Then I should be following "Jason Calleiro"

  Scenario: I want to unfollow the users that are following the artist
    Given I am logged in
    And the following user
      | name           | slug      | short_bio        | born_on    | websites                   |
      | Jason Calleiro | jcalleiro | Waaa I'm a slore | 1980-06-03 | www.facebook.com/jcalleiro |
    And I am following these users
      | name           | slug      | started following |
      | Jason Calleiro | jcalleiro | 2007-08-31        |
    And user jcalleiro is following these artists
      | name | slug | started following |
      | Mana | mana | 2007-08-31        |
    When I go to Mana's followers page
    Then I should see "Jason Calleiro"
    And for "Jason Calleiro" I click "Following"
    Then I should not be following "Jason Calleiro"
