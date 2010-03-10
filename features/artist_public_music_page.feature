# http://www.pivotaltracker.com/story/show/386588
@artist_public
Feature: Artist Public - Music page - List view module
  As a user of the site, visiting an artists page,
  I would like to see a listing of all the artists albums/works

  Acceptance Criteria:
  - Header reads "[Artist name] ALBUMS"
  - Sub-text reads "Albums"
  - Right aligned: Value: Count of total albums
  - Sub header lists 1:N filtered views  "All Time", "[year]", "[year]"  (years need definition) Update: This is not required for phase 1

  -line item contents include:
  --Album photo (60x60)
  --Album Name
  --Album Year
  --Album Label
  --Count of tracks
  --Total Album Length
  --Sorted by Album release year descending

  Actions:
  -Play icon - redirects user to the Album detail page and auto starts playing the first song
  -Share icon - invokes the share layer (phase 2)

  Scenario: On the artist home page I want to see the artists album covers
    Given the following artists 
      |name           |slug       |
      |Mana           |mana       |
    And artist mana has the following songs on album "Album 1"
      |song                  |artist       |length in seconds|total listens  |
      |I am the highway      |Mana         |120              |10             |
      |I am on the pay train |Mana         |120              |5              |
      |Pooper train          |Mana         |120              |20             |
    And artist mana has the following songs on album "Album 2"
      |song                  |artist       |length in seconds|total listens  |
      |I am the highway      |Mana         |120              |10             |
      |I am on the pay train |Mana         |120              |5              |
    And artist mana has the following songs on album "Album 3"
      |song                  |artist       |length in seconds|total listens  |
      |Pooper train          |Mana         |120              |20             |
    When I go to Mana's albums page
    Then I should see the following albums
      |Album 1|
      |Album 2|
      |Album 3|          
