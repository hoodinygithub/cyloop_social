# http://www.pivotaltracker.com/story/show/407224
Feature: Consumer Public - Playlist page - List view
  As a user of the site, visiting a Consumers page,
  I would like to see the summary of Playlists created by the person I am visiting

  Acceptance Criteria:
  - Header reads "PLAYLISTS"
  - Sub-text reads "Last Playlist Created On: [Date]"
  - Right aligned: Value: Count of total playlists
  - Sub header reads: "View: Playlist"
  - List all playlists sorted by created date descending

  Line item contents include:
  - Profile photo (60x60)
  - Playlist Name
  - Created on [Date/tme]
  - Comment(x)  - count of total comments on playlist
  - Contains: [list of  0:5 random artists - distinct]
  - Count of tracks
  - Total Time Length of all songs

  Actions:
  - Play icon - redirects user to the playlist  detail page
  - Share icon - invokes the share layer
  - Comment(x) - hyperlink to view inline comments
  - post comment form visible - only if logged in

  Scenario: I should not see Edit or Delete
    Given I am logged in
    And the following user
      |name           |slug       |short_bio        |born_on        |websites                  |
      |Jason Calleiro |jcalleiro  |Waaa I'm a slore |1980-06-03     |www.facebook.com/jcalleiro|
    And jcalleiro has the following playlists
      |name              |created_at      |
      |Boring Workplace  |2009-01-15 13:15|
    When I go to Jason Calleiro's playlists page
    Then I should not see "Edit"
    And I should not see "Delete"

  Scenario: I want to see playlists header
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And jcalleiro has the following playlists
      |name              |created_at      |
      |Boring Workplace  |2009-01-15 13:15|
      |Hip College Party |2009-01-19 13:15|
      |Reggaeton Memories|2009-01-11 13:15|
      |70's Love Hits    |2009-01-15 11:15|
    When I go to Jason Calleiro's playlists page
    Then I should see a "Jason Calleiro's Playlists" heading

  Scenario: I want to see playlists sub header
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And jcalleiro has the following playlists
      |name              |created_at      |
      |Boring Workplace  |2009-01-15 13:15|
      |Hip College Party |2009-01-19 13:15|
      |Reggaeton Memories|2009-01-11 13:15|
      |70's Love Hits    |now|
    When I go to Jason Calleiro's playlists page
    Then I should see "Last Playlist Created less than a minute ago"

  Scenario: I want to see view playlists sub header
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And jcalleiro has the following playlists
      |name              |created_at      |
      |Boring Workplace  |2009-01-15 13:15|
    When I go to Jason Calleiro's playlists page
    Then I should see a view "All" filter 

  Scenario: View my playlists
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And jcalleiro has the following playlists
      |name              |created_at      |
      |Boring Workplace  |2009-01-15 13:15|
      |Hip College Party |2009-01-19 13:15|
      |Reggaeton Memories|2009-01-11 13:15|
      |70's Love Hits    |2009-01-15 11:15|
    When I go to Jason Calleiro's playlists page
    Then I should see the following playlists in this order
      |Hip College Party |
      |Boring Workplace  |
      |70's Love Hits    |
      |Reggaeton Memories|

  Scenario: I want to see number of playlists
    Given I am logged in
    And the following user
      |name           |slug       |
      |Jason Calleiro |jcalleiro  |
    And jcalleiro has the following playlists
      |name              |created_at      |
      |Boring Workplace  |2009-01-15 13:15|
      |Hip College Party |2009-01-19 13:15|
      |Reggaeton Memories|2009-01-11 13:15|
      |70's Love Hits    |2009-01-15 11:15|
    When I go to Jason Calleiro's playlists page
    Then I should see "4"
    Then I should see "Playlists"
