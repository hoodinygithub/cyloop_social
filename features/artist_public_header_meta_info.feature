# http://www.pivotaltracker.com/story/show/385882
@artist_public
Feature: Artist Public Profile Page  - Page Header - Meta module
  As a user of the site, visiting an artists page,
  I would like to see the meta information of the artist so that I know who I am visiting

  Acceptance Criteria:
  - The header should display a thumbnail of the artist's avatar photo (60x60)
  - the artist's/band name
  - the artists City, State

  Scenario: I want to see the meta data on the artist header 
    Given the following artists 
      | name | slug |
      | Mana | mana |
    When I go to Mana's page
    Then I should see "Mana"
    And I should see "Miami, Florida, United States"
