# http://www.pivotaltracker.com/story/show/386675
@artist_public
Feature: Artist Public - Music page - Detail album view - About this Album module
  As a user of the site, visiting an artists page,
  I would like to see the meta details of the album I am listening to

  Acceptance Criteria:
  - Module header reads "ABOUT THIS ALBUM"
  - Album photo (276x276) with jewelcase overlay
  - Meta details include
  --Label: [Name of Label]
  --Release Date: [date of release]
  --Total Plays: [count of song play > 30 seconds]

  Scenario: On the artist home page I want to see the artists album detail 
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
    And I should see "Label:" 
    And I should see "Release Date: July 23, 2007"
    And I should see "Total Plays: 35"
