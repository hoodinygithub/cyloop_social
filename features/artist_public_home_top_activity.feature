# http://www.pivotaltracker.com/story/show/386052
@artist_public
Feature: Artist Public - Home page - Top Activity - Album  View module
  As a user of the site, visiting an artists page,
  I would like to see a list of highest ranked albums inorder to check out more of their popular works

  Acceptance Criteria:
  - Module header reads "TOP ACTIVITY"
  - Sub-header link reads "Albums"
  - line item contents include:
  - album photo (60x60)
  - Album Name
  --Album name hyperlinks to the Album detail page
  - Bar chart variable in width based on total play counts for that album (song play counts rolled up)
  - Text on bar with count of total song plays >= 30 seconds, of type full, where listener!=song owner, (network wide)
  - Sorted by count descending
  - Max 5 line items

  Scenario: I want to see the top albums on the home page 
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
    When I go to Mana's page
    Then I should see the following albums in this order
      |Album 1          |
      |Album 3          |