# http://www.pivotaltracker.com/story/show/372079
Feature: Consumer Private - Dashboard - Activity Feed (Songs)
  I want to see a list of songs that have been played by my friends and I
  As a registered user
  So that I can see what is popular and learn about new music I might like

  
  # Scenario: list of songs that have been played by me and my friends
  #   Given I am logged in
  #   And I have activated my account
  #   And I have listened to "Echoes" by "Pink Floyd" 1 time
  #   And my friend "David" has listened to "You Blew It" by "The Simpsons" 1 time
  #   And I have listened to "Movement" by "Rootz Underground" 1 time
  #   And my friend "Jason" has listened to "Inline Font Tags" by "The Haml All-Stars" 1 time
  #   When I go to my dashboard page
  #   Then I should see the following listen activity
  #     |song_name             |artist_name         |listener_name|
  #     |Echoes                |Pink Floyd          |Me           |
  #     |You Blew It           |The Simpsons        |David        |
  #     |Movement              |Rootz Underground   |Me           |
  #     |Inline Font Tags      |The Haml All-Stars  |Jason        |
      
#  Scenario: limit song list to 15
#    Given I am logged in
#    And I have activated my account
#    And I have played 16 songs
#    When I go to my dashboard page
#    Then I should see 15 listen activity items
#
#  Scenario: thumbnail of listener
#    Given I am logged in
#    And I have listened to "Echoes" by "Pink Floyd" 1 time
#    When I go to my dashboard page
#    Then I should see my avatar
#    
#  Scenario: add listened song to playlist
#    Given I am logged in
#    And I have activated my account
#    And I have listened to "Echoes" by "Pink Floyd" 1 time
#    When I get my "listen" activity
#    Then "Add Song to Playlist" should match against the HTML
#
  # Scenario: link listener's name to their profile page
  #   Given I am logged in
  #   And my friend "David" has listened to "You Blew It" by "The Simpsons" 1 time
  #   When I go to my dashboard page
  #   And I click the link for the user "David"
  #   Then I should be on David's page


