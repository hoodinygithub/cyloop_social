# http://www.pivotaltracker.com/story/show/386322
@artist_public
Feature: Artist Public - Charts page - Songs View
  As a user of the site, visiting an artists page,
  I would like to see the top songs from this artist

  Acceptance Criteria:
  - Module header reads "CHARTS"
  - Sub-Header to filter view that reads "Filter By:" Songs & Albums
  - Songs pane is selected by default
  - Initial view shows the top 10 songs ordered by play count descending
  - Pagination links at the bottom

  Line item contents include:
  - Rank number
  - display [Song name] in [Album Name]
  -- Song name hyperlinks to the album detail page with song autoplaying
  -- Album name hyperlinks to the album detail page
  -Play icon redirects to the Album detail page with song autoplaying
  - Bar chart variable in width based on play counts
  - Text on bar with count of total song plays >= 30 seconds, of type full, where listener!=song owner, (network wide)
  - Sorted by play count descending
  - Cap pagination to max 100

  Scenario: On the artist charts page I want to see the artists songs
    Given the following artists 
      | name | slug |
      | Mana | mana |
    And artist mana has the following songs on album "Album 1"
      | song                  | artist | length in seconds | total listens |
      | I am the highway      | Mana   | 120               | 10            |
      | I am on the pay train | Mana   | 120               | 5             |
      | Pooper train          | Mana   | 120               | 20            |
    When I go to Mana's charts songs page
    Then I should see the following songs
      | Pooper train          |
      | I am the highway      |
      | i-am-on-the-pay-train |
      
   # https://hoodiny.hoptoadapp.com/errors/459380
   Scenario: Requires login            
    Given I log out                   
    When I go to my charts songs page 
    Then I should be on the new session page
