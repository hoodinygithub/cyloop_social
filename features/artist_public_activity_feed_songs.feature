# http://www.pivotaltracker.com/story/show/386149
@artist_public
Feature: Artist Public - Home page - Activity Feed module for Songs
  In order to see whos playing the artists songs,
  As a user of the site, visiting an artists page,
  display a dynamic list of song play activities, from anyone logged in, with inline play actions and features

  Acceptance Criteria:
  - Module header reads "ACTIVITY FEED"
  - display max 15 most recent  songs that have been played
  - sort listing by activity date/time descending
  - pagination links at the bottom

  for each song display:
  - thumbnail: of the person who took the action, links to their profile
  - play icon: plays song in player
  - add icon: adds song to a playlist (for consumers only)
  - song title: plays song in player
  - Artist name: links to artist profile page
  - played by (user): links to user profile page
  - date/time: real time of post

#  Scenario: List of songs that have been played by users
#    Given I am logged in
#    And the following user 
#      | name          | slug     | short_bio              | born_on    | websites                  |
#      | David Salazar | dsalazar | Waaa Jasons is a slore | 1980-06-03 | www.facebook.com/dsalazar |
#    And the following artist
#      | name | slug |
#      | Mana | mana |
#    And user dsalazar listened to "Echoes" by "Mana" 1 time
#    And user dsalazar listened to "Movement" by "Mana" 1 time
#    When I go to Mana's activity feed
#    Then I should see the following listen activity
#      | song_name | artist_name | listener_name |
#      | Echoes    | Mana        | David Salazar |
#      | Movement  | Mana        | David Salazar |
