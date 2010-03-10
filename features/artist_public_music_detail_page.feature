# http://www.pivotaltracker.com/story/show/386622
@artist_public
Feature: Artist Public - Music page - Detail playlist view module
  As a user of the site, visiting an artists page,
  I would like to see the list of songs tied to a particular album/work

  Acceptance Criteria:
  - Header reads "[Artist name] ALBUMS"
  - Sub-text reads "Albums >> [Album name]"
  - Right aligned: Value: Count of total songs and total album duration

  -line item contents include:
  --Album photo (60x60)
  --Song Name
  --Song Length
  --Total Album Length

  Actions:
  -Play icon - allows for inline play
  -Add to playlist icon (available to consumers only, artists dont show, anons redirect to login flow)

  Scenario: On the artist home page I want to see the artists album covers
    Given the following artists 
      |name           |slug       |
      |Mana           |mana       |
    And artist mana has the following songs on album "Album 1"
      |song                  |artist       |length in seconds|total listens  |
      |I am the highway      |Mana         |120              |10             |
      |I am on the pay train |Mana         |120              |5              |
      |Pooper train          |Mana         |120              |20             |
    When I go to Mana's albums page
    Then I should see the following albums
      |Album 1          |
    When I click "play"
    Then I should see album image detail "Album 1" 
    And I should see "I am on the pay train"
    And I should see "Pooper train"
