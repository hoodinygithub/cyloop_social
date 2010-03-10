# http://www.pivotaltracker.com/story/show/375948
Feature: Drag and Drop Sorting of Playlist Songs
  So that I can re-order a playlist,
  As a logged-in user looking at a playlist I created,
  I want the ability to drag-and-drop songs in my playlist into the desired order.

  Acceptance Criteria:
  - hovering over a song in my playlist gives me a visual indicator that I'm able to drag-sort
  - the new ordering is saved via Ajax when the song is dropped into the new ordering.
  - transient status message indicates that the new ordering was saved on the server

  Scenario: Change order of songs in playlist
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      |artist      |song              |
      |Pink Floyd  |Echoes            |
      |Led Zeppelin|Stairway to Heaven|
      |Tool        |Parabola          |
    When I change the position of song "Echoes" to "2" in playlist "Rock Hits"
    And I go to my playlists page
    And I follow "Rock Hits"
    Then I should see the following songs in this order
      |Stairway to Heaven|
      |Echoes            |
      |Parabola          |
