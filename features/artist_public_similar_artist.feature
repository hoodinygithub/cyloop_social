# http://www.pivotaltracker.com/story/show/385999
@artist_public
Feature: Artist Public - Home page - Similar Artists module
  As a user of the site, visiting an artists page,
  I would like to see a list of artists similar to the one I am viewing in order to check out other artists similar to the one I like

  Acceptance Criteria:
  - Module header reads "SIMILAR ARTISTS"
  - contents include:
  - max 3 artist thumbnails (90x90)
  - artist name under each image
  - image and name hyperlinked to the artists profile

  Scenario: On the artist page I want to see similar artists
    Given the following artists
      |name         |slug       |
      |Mana         |mana       |
    When I go to Mana's js formatted similar artist page
    Then there should be 3 similar artists in the generated javascript