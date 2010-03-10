# http://www.pivotaltracker.com/story/show/407028
Feature: Consumer Public Profile Page - Home - Activity Feed - Songs 
  As a user of the site, visiting a Consumers page,
  I would like to see the list of Songs played by the person I am visiting and the people they are following.

  Acceptance criteria:
  - display up to 15 of the most recent songs that have been played by consumer or people they are following

  for each song display:
  - Div: entire div is clickable and starts the station playing
  - thumbnail: of the user who played it
  - Name of song and Artist
  - Artist name is hyerlinked to the artists profile
  - Date/Tine of play
  - Played by: links to profile of the user who played the song

  Player Actions:
  - play icon: starts station in player
  - comment: add comment about the song
  - Add to playlist icon - invokes the Add to playlist stories
  - Share icon - invokes the Share song stories

  # Scenario: list of songs that have been played by user and his friends
  #   Given I am logged in
  #   And the following user 
  #     |name           |slug       |short_bio        |born_on        |websites                  |
  #     |Jason Calleiro |jcalleiro  |Waaa I'm a slore |1980-06-03     |www.facebook.com/jcalleiro|
  #   And user jcalleiro listened to "Echoes" by "Pink Floyd" 1 time
  #   And user jcalleiro listened to "Movement" by "Rootz Underground" 1 time
  #   And profile jcalleiro friend "David" has listened to "You Blew It" by "The Simpsons" 1 time
  #   When I go to Jason Calleiro's page
  #   Then I should see the following listen activity
  #     |song_name             |artist_name         |listener_name|
  #     |Echoes                |Pink Floyd          |Jason        |
  #     |Movement              |Rootz Underground   |Jason        |
  #   And I should not see the following listen activity
  #     |song_name             |artist_name         |listener_name|
  #     |You Blew It           |The Simpsons        |David        |
      
 # Scenario: limit song list to 15
 #   Given I am logged in
 #   And I have played 16 songs
 #   When I go to my dashboard page
 #   Then I should see 15 listen activity items
 #
#  Scenario: thumbnail of listener
#    Given I am logged in
#    And I have listened to "Echoes" by "Pink Floyd" 1 time
#    When I go to my dashboard page
#    Then I should see my avatar
#
#  Scenario: add listened song to playlist
#    Given I am logged in
#    And I have listened to "Echoes" by "Pink Floyd" 1 time
#    When I go to my dashboard page
#    Then "Add Song to Playlist" should match against the HTML
#
  # Scenario: link listener's name to their profile page
  #   Given I am logged in
  #   And my friend "David" has listened to "You Blew It" by "The Simpsons" 1 time
  #   When I go to my dashboard page
  #   And I click the link for the user "David"
  #   Then I should be on David's page 
