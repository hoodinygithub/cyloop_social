# http://www.pivotaltracker.com/story/show/386040
@artist_public
Feature: Artist Public - Home page - Top Activity - Songs View module
  As a user of the site, visiting an artists page,
  I would like to see a list of highest ranked songs inorder to check out more of their popular songs

  Acceptance Criteria:
  - Module header reads "TOP ACTIVITY"
  - Sub-header link reads "Songs" (selected by default)
  - line item contents include:
  - Album photo (60x60)
  - [Song Name] in [Album Name]
  -- Song name hyperlinks to the Album detail page with song auto playing
  --Album name hyperlinks to the album detail page

  - Bar chart variable in width based on play counts
  - Text on bar with count of total song plays >= 30 seconds, of type full, where listener!=song owner, (network wide)
  - Sorted by play count descending
  - Max 5 line items

  Scenario: I want to see the top songs on the home page 
    Given the following artists 
      | name | slug |
      | Mana | mana |
    And artist mana has the following songs on album "Album 1"
      | song                  | artist | length in seconds | total listens |
      | I am the highway      | Mana   | 120               | 10            |
      | I am on the pay train | Mana   | 120               | 5             |
      | Pooper train          | Mana   | 120               | 2000          |
    When I go to Mana's page to see the songs
    Then I should see the following top songs in this order
      | Pooper train     |
      | I am the highway |
