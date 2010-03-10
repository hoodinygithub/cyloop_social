# http://www.pivotaltracker.com/story/show/386096
@artist_public
Feature: Artist Public - Home page - Albums module
  As a user of the site, visiting an artists page,
  I would like to see a list of the artists albums so that I can peruse through their collection of works

  Acceptance Criteria:
  - Module header reads "ALBUMS"
  - contents include:
  - max 6 album thumbnails (86x86)
  - if albums exceed 6, then paginate with foward and back actions
  - pagination text example: "Showing 1 - 6 Albums out of 10"
  - sort by release year descending
  - if artist has no albums then supress module
  - album photo is hyperlinked to the album detail page

  Scenario: On the artist home page I want to see the artists album covers
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
    When I go to Mana's page
    Then I should see the following album images
      | Album 1 |
      | Album 2 |
      | Album 3 |
