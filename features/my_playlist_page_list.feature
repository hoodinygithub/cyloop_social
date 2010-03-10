# http://www.pivotaltracker.com/story/show/441817
Feature: Consumer Private - Playlist page - list view
  In order to view and/or manage my playlists
  As a user
  I want to access my Playlists page

  Acceptance criteria:
  - In private view, show playlist tab with editing capabilities (RUD)

  Lineitem details include:
  - profile photo
  - playlist name
  - playlist create date/time
  - Contains: sampling of artists contained within playlist (1:4)
  - Total count of songs
  - Total duration of all songs

  Actions:
  - play icon; redirects to the playlist detail page
  - delete icon; deletes playlist and all songs tied to it

  -Share; phase 2
  -Comments; phase 2

  Scenario: I want to delete a playlist
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      |artist      |song              |length in seconds|
      |Pink Floyd  |Echoes            |240              |
    When I go to my playlists page
    And I click "Delete"
    And I have a playlist named "Rock Hits"
    Then I click "Continue"
    And I should see "Dashboard"
    

  Scenario: I want to go to the playlist detail page
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      |artist      |song              |length in seconds|
      |Pink Floyd  |Echoes            |240              |
    When I go to my playlists page
    And I click "Rock Hits"
    Then I should be on my playlist page 
    And I should see "Pink Floyd"

  Scenario: I want to go to the playlist detail page and have autoplay enabled
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      |artist      |song              |length in seconds|
      |Pink Floyd  |Echoes            |240              |
    When I go to my playlists page
    And I click "Play"
    Then I should have autoplay enabled and be on my playlist page 
    And I should see "Pink Floyd"


  Scenario: Edit playlist name
    Given I am logged in
    And I have a playlist named "Rock Hits" 
    When I go to my playlists page
    And I click edit for playlist "Rock Hits"
    And I fill in "playlist[name]" with "Nin"
    And I click "Save"
    Then I should see "Nin"
