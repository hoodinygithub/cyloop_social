# http://www.pivotaltracker.com/story/show/386373
@artist_public
Feature: Artist Public - Charts page - Albums View
  As a user of the site, visiting an artists page,
  I would like to see the top albums/works from this artist

  Acceptance Criteria:
  - Module header reads "CHARTS"
  - Sub-Header to filter view that reads "Filter By:" Songs & Albums
  - Albums view is selected
  - Initial view shows the top 10 albums ordered by total play count descending (see business rules at to what qualifies a playcount)
  - Pagination links at the bottom

  Line item contents include:
  - Display Rank number, Album photo (64x64), [Album name]
  - Play icon redirects to the Album detail page
  - Bar chart variable in width based on total play counts for that album (network wide)
  - Text on bar with count of total song plays >= 30 seconds, of type full, where listener!=song owner, (network wide)
  - Sorted by total album plays descending
  - Cap pagination to max 100

  Scenario: On the artist charts page I want to see the artists albums
    Given the following artists 
      | name | slug |
      | Mana | mana |
    And artist mana has the following songs on album "Album 1"
      | song                  | artist | length in seconds | total listens |
      | I am the highway      | Mana   | 120               | 10            |
      | I am on the pay train | Mana   | 120               | 5             |
      | Pooper train          | Mana   | 120               | 20            |
    And artist mana has the following songs on album "Album 2"
      | song                  | artist | length in seconds | total listens |
      | I am the highway      | Mana   | 120               | 10            |
      | I am on the pay train | Mana   | 120               | 5             |
    And artist mana has the following songs on album "Album 3"
      | song         | artist | length in seconds | total listens |
      | Pooper train | Mana   | 120               | 20            |
    When I go to Mana's charts albums page
    Then I should see the following albums
      | Album 1 |
      | Album 3 |
      | Album 2 |
