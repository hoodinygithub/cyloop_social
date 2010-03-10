# http://www.pivotaltracker.com/story/show/375919
Feature: My Playlists
  In order to manage my playlists,
  As a logged-in user
  I want a tab on my dashboard which shows me a list of playlists that I have created.

  Acceptance Criteria:
  - Heading reads "MY PLAYLISTS"
  - small text under heading indicates when the last playlist was created
  - The number of playlists is shown right-aligned in the header area
  - Each playlist entry contains:
  --- title
  --- when the playlist was created
  --- the number of comments
  --- a "Contains" statement with some of the artists (logic TBD)
  --- a right-side section containing the number of songs and total length of the playlist

  # https://hoodiny.hoptoadapp.com/errors/475926
  Scenario: Requires login
    Given I log out
    When I go to my playlists page
    Then I should be on the login page  

  Scenario: View my playlists
    Given I am logged in
    And I have the following playlists
      | name               | created_at       |
      | Boring Workplace   | 2009-01-15 13:15 |
      | Hip College Party  | 2009-01-19 13:15 |
      | Reggaeton Memories | 2009-01-11 13:15 |
      | 70's Love Hits     | 2009-01-15 11:15 |
    When I go to my playlists page
    Then I should see the following playlists in this order
      | Hip College Party  |
      | Boring Workplace   |
      | 70's Love Hits     |
      | Reggaeton Memories |

  Scenario: Show artists contained in playlist
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      | artist       | song               |
      | Pink Floyd   | Echoes             |
      | Led Zeppelin | Stairway to Heaven |
      | Tool         | Parabola           |
    When I go to my playlists page
    Then I should see the following artists contained in "Rock Hits"
      | Pink Floyd   |
      | Led Zeppelin |
      | Tool         |

  Scenario: Playlist shows number of songs
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      | artist       | song               |
      | Pink Floyd   | Echoes             |
      | Led Zeppelin | Stairway to Heaven |
      | Tool         | Parabola           |
    When I go to my playlists page
    Then I should see the "3" as the count for songs in the playlist "Rock Hits"

  Scenario: Playlist shows length of time of playlist
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      | artist       | song               | length in seconds |
      | Pink Floyd   | Echoes             | 240               |
      | Led Zeppelin | Stairway to Heaven | 279               |
      | Tool         | Parabola           | 315               |
    When I go to my playlists page
    Then I should see the "13:54" as the total length for the playlist "Rock Hits"
    
  # http://www.pivotaltracker.com/story/show/888699
  Scenario: Playlist shows length of time in format HH:MM:SS when total time is more than a hour
    Given I am logged in
    And I have a playlist named "Rock Hits"
    And I have the following songs on playlist "Rock Hits"
      | artist       | song               | length in seconds |
      | Pink Floyd   | Echoes             | 240               |
      | Led Zeppelin | Stairway to Heaven | 279               |
      | Tool         | Parabola           | 315               |
      | Pink Floyd   | Echoes             | 3600              |
    When I go to my playlists page
    Then I should see the "01:13:54" as the total length for the playlist "Rock Hits"        

  # https://hoodiny.hoptoadapp.com/errors/475926
  Scenario: Requires login
    Given I am logged in
    And I have a playlist named "Rock Hits"    
    And I log out
    When I go to my "Rock Hits" playlist page
    Then I should be on the login page    
