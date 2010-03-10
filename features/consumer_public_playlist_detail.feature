# http://www.pivotaltracker.com/story/show/407318
Feature: Consumer Public - Playlist page - Detail view
  As a user of the site, visiting a Consumers page,
  I would like to see the contents of a selected Playlist created by the person I am visiting

  Acceptance Criteria:
  - Header reads "[NAME OF PLAYLIST]"
  - Sub-text reads "Created On: [Date]"
  - Right aligned: Value: Count of total playlists
  - Right aligned: Value: Total time
  - Sub header reads: "View: Playlist, [Name of playlist]"

  -List all songs sorted by sequence setting

  -line item contents include:
  - Album photo  that song belongs to(60x60)
  - Display: [Song Name] by [Artistname]
  - Artist name is hyperlinked to Artists profile
  - Length: [duration]
  - Comment(x)  - count of total comments on playlist

  Actions:
  - Play icon - invokes inline play of song
  - Share icon - invokes the share layer
  - Add to playlist icon - adds song to logged in

  Scenario: Header is shown correctly for a consumers public playlist
    Given the following user
      |name           |slug       |short_bio        |born_on        |websites                  |
      |Jason Calleiro |jcalleiro  |Waaa I'm a slore |1980-06-03     |www.facebook.com/jcalleiro|
    And user jcalleiro has the following songs on playlist "SOBE hits"
      |song             |artist       |length in seconds|
      |I am the highway |Audio Slave  |120              |
    When I go to Jason Calleiro's playlists page
    And I click "Play"
    Then I should see "SOBE hits"
    And I should see "Created less than a minute ago"
    And I should see "1 Song"
    And I should see "Total Time: 02:00"
